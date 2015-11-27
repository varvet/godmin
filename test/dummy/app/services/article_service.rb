class ArticleService
  include Godmin::Resources::ResourceService

  attrs_for_index :id, :title, :published, :created_at
  attrs_for_show :id, :title, :body, :published
  attrs_for_form :title, :body, :published

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

  batch_action :destroy
  batch_action :publish
  batch_action :unpublish

  def batch_action_destroy(articles)
    articles.destroy_all
  end

  def batch_action_publish(articles)
    articles.update_all(published: true)
  end

  def batch_action_unpublish(articles)
    articles.update_all(published: false)
  end
end
