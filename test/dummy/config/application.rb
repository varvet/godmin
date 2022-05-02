require File.expand_path("../boot", __FILE__)

require "rails/all"

Bundler.require(*Rails.groups)
require "godmin"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails.version[/^\d+\.\d+/]
  end
end
