# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

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

module Godmin
  class TestArticle < ActiveRecord::Base
    mattr_accessor :called_filters do
      {}
    end

    include Godmin::Model

    filter :title
    filter :country, as: :select, collection: %w(Sweden Canada)

    def self.filter_title(value)
      called_filters[:title] = value
      all
    end

    def self.filter_country(value)
      called_filters[:country] = value
      all
    end
  end
end
