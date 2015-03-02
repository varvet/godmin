# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "minitest/reporters"

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(
  color: true
)]

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

def namespaced_as(namespace)
  Godmin.namespace = namespace
  yield
  Godmin.namespace = nil
end

# module Godmin
  class Article
  end

  class ArticleService
    include Godmin::Resources::ResourceService

    mattr_accessor :called_methods do
      { scopes: {}, filters: {}, batch_actions: {} }
    end

    attrs_for_index :id, :title, :country
    attrs_for_form :id, :title, :country, :body

    scope :unpublished, default: true
    scope :published

    filter :title
    filter :country, as: :select, collection: %w(Sweden Canada)

    batch_action :unpublish
    batch_action :publish, confirm: true, only: :unpublished, except: :published

    def resources_relation
      [:foo, :bar, :baz]
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

    def batch_action_unpublish(resources)
      called_methods[:batch_actions][:unpublish] = resources
    end

    def batch_action_publish(resources)
      called_methods[:batch_actions][:publish] = resources
    end
  end
# end
