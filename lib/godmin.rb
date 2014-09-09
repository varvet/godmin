require "bootstrap-sass"
require "devise"
require "kaminari"
require "select2-rails"
require "simple_form"
require "godmin/engine"
require "godmin/rails"
require "godmin/version"

module Godmin
  mattr_accessor :mounted_as
  self.mounted_as = nil

  mattr_accessor :resources
  self.resources = []

  def self.configure
    yield self
  end
end
