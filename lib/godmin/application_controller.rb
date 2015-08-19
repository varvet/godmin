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
      helper_method :blamespace

      before_action :prepend_view_paths

      layout "godmin/application"
    end

    def welcome; end

    private

    def blamespace
      return unless engine_constant
      engine_constant.to_s.underscore
    end

    def engine_constant
      GodminEngine.foo(self)
    end

    class GodminEngine
      def self.foo(obj)
        engine = obj.class.to_s.deconstantize.split("::").reverse.map(&:constantize).detect do |mod|
          mod.respond_to?(:use_relative_model_naming?) && mod.use_relative_model_naming?
        end
        if engine
          RealEngine.new(engine)
        else
          FakeEngine.new
        end
      end
    end

    class RealEngine
      attr_reader :engine
      def intialize(engine)
        @engine = engine
      end

      def root
        engine.root
      end

      def name
        engine.engine_name
      end
    end

    class FakeEngine
      def root
        Rails.application.root
      end

      def name
        nil
      end
    end

    def prepend_view_paths
      append_view_path Godmin::ResourceResolver.new(controller_path, engine_constant)
      append_view_path Godmin::GodminResolver.new(controller_path, engine_constant)
    end

    def authentication_enabled?
      singleton_class.include?(Godmin::Authentication)
    end

    def authorization_enabled?
      singleton_class.include?(Godmin::Authorization)
    end
  end
end
