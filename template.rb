require "active_support/all"

def install_standalone
  set_ruby_version

  gem "godmin", "1.3.0"

  after_bundle do
    create_database

    generate_models

    generate("godmin:install")
    generate("godmin:resource", "article")
    generate("godmin:resource", "author")

    modify_rakefile
    modify_routes
    modify_locales
    modify_models
    modify_author_service
    modify_article_controller
    modify_article_service

    migrate_and_seed
  end
end

def install_engine
  set_ruby_version

  run_ruby_script("bin/rails plugin new admin --mountable")

  gsub_file "admin/admin.gemspec", "TODO: ", ""
  gsub_file "admin/admin.gemspec", "TODO", ""

  inject_into_file "admin/admin.gemspec", before: /^end/ do
    <<-END.strip_heredoc.indent(2)
      s.add_dependency "godmin", "~> 1.0.0"
    END
  end

  gem "admin", path: "admin"

  after_bundle do
    create_database

    generate_models

    run_ruby_script("admin/bin/rails g godmin:install")
    run_ruby_script("admin/bin/rails g godmin:resource article")
    run_ruby_script("admin/bin/rails g godmin:resource author")

    inject_into_file "config/routes.rb", before: /^end/ do
      <<-END.strip_heredoc.indent(2)
        mount Admin::Engine, at: "admin"
      END
    end

    modify_rakefile
    modify_routes("admin")
    modify_locales
    modify_models
    modify_author_service("admin")
    modify_article_controller("admin")
    modify_article_service("admin")

    migrate_and_seed
  end
end

def set_ruby_version
  prepend_to_file "Gemfile" do
    "ruby '2.2.2'\n"
  end
end

def create_database
  rake("db:drop")
  rake("db:create")
end

def generate_models
  generate(:model, "author name:string")
  generate(:model, "article title:string body:text author:references published:boolean published_at:datetime")

  gsub_file Dir.glob("db/migrate/*_create_articles.rb").first, "t.boolean :published", "t.boolean :published, default: false"

  append_to_file "db/seeds.rb" do
    <<-END.strip_heredoc
      def title
        5.times.map { lorem.sample }.join(" ").capitalize
      end

      def lorem
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.".gsub(/[.,]/, "").downcase.split(" ")
      end

      def author
        Author.all.sample
      end

      def published
        [true, true, false].sample
      end

      def published_at
        Time.now - [0, 1, 2, 3, 4, 5].sample.days
      end

      ["Lorem Ipsum", "Magna Aliqua", "Commodo Consequat"].each do |name|
        Author.create name: name
      end

      35.times do |i|
        Article.create! title: title, author: author, published: published, published_at: published_at
      end
    END
  end
end

def modify_rakefile
  append_to_file "RakeFile" do
    <<-END.strip_heredoc

      namespace :sandbox do
        desc "Reseed the database"
        task reseed: :environment do
          Rake::Task["sandbox:reset"].invoke
          Rake::Task["db:schema:load"].invoke
          Rake::Task["db:seed"].invoke
        end

        desc "Reset the database"
        task reset: :environment do
          ActiveRecord::Base.connection.tables.each do |table|
            if table != "schema_migrations"
              query = "DROP TABLE IF EXISTS \#{table} CASCADE;"
              ActiveRecord::Base.connection.execute(query)
            end
          end
        end
      end
    END
  end
end

def modify_locales
  append_to_file "config/locales/en.yml" do
    <<-END.strip_heredoc.indent(2)

    activerecord:
      models:
        article:
          one: Article
          other: Articles
        author:
          one: Author
          other: Authors
    END
  end
end

def modify_routes(namespace = nil)
  routes_file =
    if namespace
      "admin/config/routes.rb"
    else
      "config/routes.rb"
    end

  gsub_file routes_file, "application#welcome", "articles#index"
end

def modify_models
  inject_into_file "app/models/article.rb", before: "end" do
    <<-END.strip_heredoc.indent(2)

      def to_s
        title
      end
    END
  end

  inject_into_file "app/models/author.rb", before: "end" do
    <<-END.strip_heredoc.indent(2)
      def to_s
        name
      end
    END
  end
end

def modify_article_controller(namespace = nil)
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

def modify_article_service(namespace = nil)
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
      filter :author, as: :select, collection: -> { Author.all }, option_text: "name"

      def filter_title(articles, value)
        articles.where("title LIKE ?", "%\#{value}%")
      end

      def filter_author(articles, value)
        articles.where(author: value)
      end

      batch_action :unpublish, except: [:unpublished]
      batch_action :publish, except: [:published]
      batch_action :destroy, confirm: true

      def batch_action_unpublish(articles)
        articles.update_all(published: false)
      end

      def batch_action_publish(articles)
        articles.update_all(published: true)
      end

      def batch_action_destroy(articles)
        articles.destroy_all
      end

      def per_page
        15
      end
    END
  end
end

def modify_author_service(namespace = nil)
  author_service =
    if namespace
      "admin/app/services/admin/author_service.rb"
    else
      "app/services/author_service.rb"
    end

  gsub_file author_service, "attrs_for_index", "attrs_for_index :name"
  gsub_file author_service, "attrs_for_show", "attrs_for_show :name"
  gsub_file author_service, "attrs_for_form", "attrs_for_form :name"

  inject_into_file author_service, after: "attrs_for_form :name \n" do
    <<-END.strip_heredoc.indent(namespace ? 4 : 2)
      attrs_for_export :id, :name

      filter :name

      def filter_name(authors, value)
        authors.where("name LIKE ?", "%\#{value}%")
      end

      batch_action :destroy, confirm: true

      def batch_action_destroy(authors)
        authors.each { |a| a.destroy }
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
