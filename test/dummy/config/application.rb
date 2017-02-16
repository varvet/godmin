require File.expand_path("../boot", __FILE__)

require "rails/all"

Bundler.require(*Rails.groups)
require "godmin"

module Dummy
  class Application < Rails::Application
    ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] = "1"
  end
end
