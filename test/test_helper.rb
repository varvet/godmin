# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] = "1"

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require "rails/test_help"
require "capybara/rails"
require "capybara/poltergeist"
require "minitest/reporters"
require "pry"

require File.expand_path("../fakes/article.rb", __FILE__)
require File.expand_path("../fakes/article_service.rb", __FILE__)

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

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

Capybara.javascript_driver = :poltergeist

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
    template_path = File.expand_path("../dummy/#{path}", __FILE__)
    @template_paths << template_path
    File.write(template_path, content)
  end
end
