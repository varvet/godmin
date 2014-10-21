require "bootstrap-sass"
require "kaminari"
require "select2-rails"
require "simple_form"
require "godmin/admin_user"
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

  mattr_accessor :admin_user_class
  self.admin_user_class = nil

  mattr_accessor :admin_user_identifier
  self.admin_user_identifier = nil

  def self.configure
    yield self
  end
end
