require "godmin/helpers/application"
require "godmin/helpers/forms"
require "godmin/helpers/navigation"
require "godmin/helpers/translations"

module Godmin
  module ApplicationController
    extend ActiveSupport::Concern

    included do
      include Godmin::Helpers::Translations

      helper Godmin::Helpers::Application
      helper Godmin::Helpers::Forms
      helper Godmin::Helpers::Navigation
      helper Godmin::Helpers::Translations

      helper_method :authentication_enabled?
      helper_method :authorization_enabled?

      before_action :prepend_view_paths

      layout "godmin/application"
    end

    def welcome; end

    private

    def prepend_view_paths
      append_view_path Godmin::ResourceResolver.new(controller_path)
      append_view_path Godmin::SharedResolver.new(controller_path)
      # prepend_view_path Godmin::GodminResolver.new(controller_name)
      # prepend_view_path Godmin::EngineResolver.new(controller_name)
    end

    def authentication_enabled?
      singleton_class.include?(Godmin::Authentication)
    end

    def authorization_enabled?
      singleton_class.include?(Godmin::Authorization)
    end
  end
end
