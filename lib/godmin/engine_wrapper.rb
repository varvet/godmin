module Godmin
  class EngineWrapper
    attr_reader :engine

    def initialize(controller)
      @engine = find_engine(controller)
    end

    def namespace
      @namespace ||= engine.railtie_namespace
    end

    def namespaced?
      @namespaced ||= namespace.present?
    end

    def namespaced_path
      @namespaced_path ||= begin
        if namespaced?
          namespace.name.split("::").map(&:underscore)
        else
          []
        end
      end
    end

    def root
      engine.root
    end

    private

    def find_engine(controller)
      engine_module = find_engine_module(controller)

      if engine_module
        "#{engine_module}::Engine".constantize
      else
        Rails.application
      end
    end

    # Some gymnastics because the `parents` function is slated for deprecation
    # and being replaced by `module_parents` and we don't want to clutter our
    # log with a million warnings
    def parents_of(controller)
      return controller.module_parents if controller.respond_to?(:module_parents)

      controller.parents
    end

    def find_engine_module(controller)
      parents_of(controller).find do |parent|
        parent.respond_to?(:use_relative_model_naming?) && parent.use_relative_model_naming?
      end
    end
  end
end
