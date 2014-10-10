# TODO: make sure list is relevant
require "bootstrap-sass"
require "cancan"
require 'select2-rails'
require "kaminari"
require "simple_form"
require "godmin/application"
require "godmin/engine"
require "godmin/helpers/batch_actions"
require "godmin/helpers/filters"
require "godmin/helpers/tables"
require "godmin/helpers/translations"
require "godmin/rails"
require "godmin/resolver"
require "godmin/resource"
require "godmin/resource/batch_actions"
require "godmin/resource/filters"
require "godmin/resource/scopes"
require "godmin/resource/ordering"
require "godmin/resource/pagination"
require "godmin/version"

module Godmin
  mattr_accessor :mounted_as
  self.mounted_as = nil

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
