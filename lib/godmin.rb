require 'bootstrap-sass'
require 'cancan'
require 'inherited_resources'
require 'kaminari'
require 'simple_form'
require 'godmin/engine'
require 'godmin/rails'
require 'godmin/version'

module Godmin
  mattr_accessor :mounted_as
  self.mounted_as = nil

  mattr_accessor :authentication_method
  self.authentication_method = false

  mattr_accessor :current_user_method
  self.current_user_method = false

  def self.configure
    yield self
  end
end
