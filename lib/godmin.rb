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
  self.mounted_as = :admin

  mattr_accessor :resources
  self.resources = []

  mattr_accessor :authentication_method
  self.authentication_method = nil

  mattr_accessor :current_user_method
  self.current_user_method = nil

  def self.configure
    yield self
  end
end
