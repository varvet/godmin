# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "capybara/rails"
require "minitest/reporters"
require "pry"

# TODO: what to call these?
require File.expand_path("../fakes/article.rb",  __FILE__)
require File.expand_path("../fakes/article_service.rb",  __FILE__)

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

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    @template_paths = []
  end

  def teardown
    @template_paths.each do |path|
      File.delete(path)
    end
  end

  private

  def add_template(path, content)
    template_path = File.expand_path("../dummy/app/views/#{path}", __FILE__)
    @template_paths << template_path
    File.write(template_path, content)
  end
end
