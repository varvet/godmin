# TODO: make sure list is relevant
require "bootstrap-sass"
require "cancan"
require 'select2-rails'
require "kaminari"
require "simple_form"
require "godmin/engine"
require "godmin/rails"
require "godmin/version"

module Godmin
  mattr_accessor :mounted_as
  self.mounted_as = :admin # TODO: set nil as default

  mattr_accessor :resources
  self.resources = []

  # mattr_accessor :authentication_method
  # self.authentication_method = false

  # mattr_accessor :current_user_method
  # self.current_user_method = false

  def self.configure
    yield self
  end
end
