class ArticleService
  include Godmin::Resources::ResourceService

  attrs_for_index :id, :title, :non_orderable_column, :admin_user, :published, :created_at
  attrs_for_show :id, :title, :body, :admin_user, :published
  attrs_for_form :title, :body, :admin_user, :published

  def order_by_admin_user(resources, direction)
    resources.joins(:admin_users).order("admin_users.email #{direction}")
  end

  scope :all
  scope :unpublished
  scope :published
  scope :no_batch_actions

  def scope_all(articles)
    articles
  end

  def scope_unpublished(articles)
    articles.where(published: false)
  end

  def scope_published(articles)
    articles.where(published: true)
  end

  def scope_no_batch_actions(articles)
    articles
  end

  filter :title
  filter :status, as: :select, collection: -> { [["Published", :published], ["Unpublished", :unpublished]] }

  def filter_title(articles, value)
    articles.where(title: value)
  end

  def filter_status(articles, value)
    articles.where(published: value == "published")
  end

  batch_action :publish, except: [:published, :no_batch_actions]
  batch_action :unpublish, except: [:unpublished, :no_batch_actions]
  batch_action :destroy, except: [:no_batch_actions]

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
