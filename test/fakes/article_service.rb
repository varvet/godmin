module Fakes
  class ArticleService
    include Godmin::Resources::ResourceService

    attr_accessor :called_methods

    attrs_for_index :id, :title, :country
    attrs_for_show :title, :country
    attrs_for_form :id, :title, :country, :body
    attrs_for_export :id, :title

    scope :unpublished, default: true
    scope :published

    filter :title
    filter :country, as: :select, collection: %w(Sweden Canada)
    filter :tags, as: :multiselect, collection: %w(Apple Banana)

    batch_action :unpublish
    batch_action :publish, confirm: true, only: [:unpublished], except: [:published]

    def initialize(*)
      super
      @called_methods = { scopes: {}, filters: {}, batch_actions: {}, ordering: {} }
    end

    def resource_class
      Fakes::Article
    end

    def resources_relation
      [:foo, :bar, :baz]
    end

    def order_by_foobar(resources, direction)
      called_methods[:ordering][:by_foobar] = [resources, direction]
      resources
    end

    def scope_unpublished(resources)
      called_methods[:scopes][:unpublished] = resources
      resources.slice(1, 3)
    end

    def scope_published(resources)
      called_methods[:scopes][:published] = resources
      resources.slice(0, 1)
    end

    def filter_title(resources, value)
      called_methods[:filters][:title] = [resources, value]
      resources
    end

    def filter_country(resources, value)
      called_methods[:filters][:country] = [resources, value]
      resources
    end

    def filter_tags(resources, value)
      called_methods[:filters][:tags] = [resources, value]
      resources
    end

    def batch_action_unpublish(resources)
      called_methods[:batch_actions][:unpublish] = resources
    end

    def batch_action_publish(resources)
      called_methods[:batch_actions][:publish] = resources
    end
  end
end
