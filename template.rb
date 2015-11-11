require "active_support/all"

def install_standalone
  add_postgres

  gem "godmin", "> 0.12"

  after_bundle do
    generate_model
    generate("godmin:install")
    generate("godmin:resource", "article")

    modify_controller
    modify_service

    migrate_and_seed
  end
end

def install_engine
  add_postgres

  run_ruby_script("bin/rails plugin new admin --mountable")

  gsub_file "admin/admin.gemspec", "TODO: ", ""
  gsub_file "admin/admin.gemspec", "TODO", ""

  inject_into_file "admin/admin.gemspec", before: /^end/ do
    <<-END.strip_heredoc.indent(2)
      s.add_dependency "godmin", "> 0.12"
    END
  end

  gem "admin", path: "admin"

  after_bundle do
    generate_model
    run_ruby_script("admin/bin/rails g godmin:install")
    run_ruby_script("admin/bin/rails g godmin:resource article")

    inject_into_file "config/routes.rb", before: /^end/ do
      <<-END.strip_heredoc.indent(2)
        mount Admin::Engine, at: "admin"
      END
    end

    modify_controller("admin")
    modify_service("admin")

    migrate_and_seed
  end
end

def add_postgres

  gsub_file "Gemfile", "sqlite3", "pg"

  db_yml = "config/database.yml"
  inject_into_file db_yml, "  adapter: postgresql\n", after: "production:\n  <<: *default\n", force: true
  gsub_file db_yml, "  database: db/production.sqlite3\n", ""

gem_group :development, :test do
    gem "sqlite3"
  end
end

def generate_model
  generate(:model, "article title:string body:text author:string published:boolean published_at:datetime")

  append_to_file "db/seeds.rb" do
    <<-END.strip_heredoc
      def title
        5.times.map { lorem.sample }.join(" ").capitalize
      end

      def lorem
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.".gsub(/[.,]/, "").downcase.split(" ")
      end

      def author
        ["Lorem Ipsum", "Magna Aliqua", "Commodo Consequat"].sample
      end

      def published
        [true, true, false].sample
      end

      35.times do |i|
        Article.create! title: title, author: author, published: published
      end
    END
  end
end

def modify_controller(namespace = nil)
  articles_controller =
    if namespace
      "admin/app/controllers/admin/articles_controller.rb"
    else
      "app/controllers/articles_controller.rb"
    end

  inject_into_file articles_controller, after: "Godmin::Resources::ResourceController\n" do
    <<-END.strip_heredoc.indent(namespace ? 4 : 2)

      private

      def redirect_after_batch_action_unpublish
        articles_path(scope: :unpublished)
      end

      def redirect_after_batch_action_publish
        articles_path(scope: :published)
      end
    END
  end
end

def modify_service(namespace = nil)
  article_service =
    if namespace
      "admin/app/services/admin/article_service.rb"
    else
      "app/services/article_service.rb"
    end

  gsub_file article_service, "attrs_for_index", "attrs_for_index :title, :author, :published_at"
  gsub_file article_service, "attrs_for_show", "attrs_for_show :title, :body, :author, :published, :published_at"
  gsub_file article_service, "attrs_for_form", "attrs_for_form :title, :body, :author, :published, :published_at"

  inject_into_file article_service, after: "attrs_for_form :title, :body, :author, :published, :published_at \n" do
    <<-END.strip_heredoc.indent(namespace ? 4 : 2)
      attrs_for_export :id, :title, :author, :published, :published_at

      scope :unpublished
      scope :published

      def scope_unpublished(articles)
        articles.where(published: false)
      end

      def scope_published(articles)
        articles.where(published: true)
      end

      filter :title
      filter :author

      def filter_title(articles, value)
        articles.where(title: value)
      end

      def filter_author(articles, value)
        articles.where(author: value)
      end

      batch_action :unpublish, except: [:unpublished]
      batch_action :publish, except: [:published]
      batch_action :destroy, confirm: true

      def batch_action_unpublish(articles)
        articles.each { |a| a.update(published: false) }
      end

      def batch_action_publish(articles)
        articles.each { |a| a.update(published: true) }
      end

      def batch_action_destroy(articles)
        articles.each { |a| a.destroy }
      end
    END
  end
end

def migrate_and_seed
  rake("db:migrate")
  rake("db:seed")
end

with_engine = "--with-engine"
without_engine = "--without-engine"

if ARGV.count > (ARGV - [with_engine, without_engine]).count
  if ARGV.include? with_engine
    install_engine
  elsif ARGV.include? without_engine
    install_standalone
  end
else
  if yes?("Place godmin in admin engine?")
    install_engine
  else
    install_standalone
  end
end
