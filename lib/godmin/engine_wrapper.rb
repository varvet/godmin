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
          namespace.name.classify.split("::").map(&:underscore)
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

    def find_engine_module(controller)
      controller.parents.find do |parent|
        parent.respond_to?(:use_relative_model_naming?) && parent.use_relative_model_naming?
      end
    end
  end
end
