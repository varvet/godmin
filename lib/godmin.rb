require "bootstrap-sass"
require "bootstrap_form"
require "momentjs-rails"
require "selectize-rails"
require "godmin/application_controller"
require "godmin/authentication"
require "godmin/authorization"
require "godmin/engine"
require "godmin/paginator"
require "godmin/rails"
require "godmin/resolver"
require "godmin/resources/resource_controller"
require "godmin/resources/resource_service"
require "godmin/version"

module Godmin
  mattr_accessor :namespace
  self.namespace = nil

  mattr_accessor :resources
  self.resources = []

  def self.configure
    yield self
  end
end
