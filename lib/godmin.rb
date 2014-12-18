require "bootstrap-sass"
require "momentjs-rails"
require "selectize-rails"
require "simple_form"
require "godmin/application"
require "godmin/authentication"
require "godmin/authorization"
require "godmin/engine"
require "godmin/rails"
require "godmin/resolver"
require "godmin/resource"
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
