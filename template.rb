gem "godmin", "~> 0.12.3"

after_bundle do
  generate(:model, "article title:string body:text published:boolean published_at:datetime")
  generate("godmin:install")
  generate("godmin:resource", "article")

  require "active_support/all"

  inject_into_file "app/controllers/articles_controller.rb", before: "end" do
    <<-END.strip_heredoc.indent(2)

      private

      def redirect_after_batch_action_unpublish
        articles_path(scope: :unpublished)
      end

      def redirect_after_batch_action_publish
        articles_path(scope: :published)
      end
    END
  end

  gsub_file "app/services/article_service.rb", "attrs_for_index", "attrs_for_index :title, :published_at"
  gsub_file "app/services/article_service.rb", "attrs_for_show", "attrs_for_show :title, :body, :published, :published_at"
  gsub_file "app/services/article_service.rb", "attrs_for_form", "attrs_for_form :title, :body, :published, :published_at"

  inject_into_file "app/services/article_service.rb", before: "end" do
    <<-END.strip_heredoc.indent(2)
      attrs_for_export :id, :title, :published, :published_at

      scope :unpublished
      scope :published

      def scope_unpublished(articles)
        articles.where(published: false)
      end

      def scope_published(articles)
        articles.where(published: true)
      end

      filter :title

      def filter_title(articles, value)
        articles.where(title: value)
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

  append_to_file "db/seeds.rb" do
    <<-END.strip_heredoc
      Article.create! title: "The first article", published: false
      Article.create! title: "The second article", published: false
      Article.create! title: "The third article", published: true, published_at: Time.zone.now
    END
  end

  rake("db:migrate")
  rake("db:seed")
end
