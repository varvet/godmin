module Godmin
  class EngineWrapper
    attr_reader :engine

    def initialize(obj)
      @engine = find_engine(obj)
    end

    def root
      engine.root
    end

    def namespace
      engine.railtie_namespace.to_s.underscore
    end

    private

    def find_engine(obj)
      mod = find_engine_module(obj)
      if mod
        "#{mod}::Engine".constantize
      else
        Rails.application
      end
    end

    def find_engine_module(obj)
      obj.class.to_s.deconstantize.split("::").reverse.map(&:constantize).detect do |mod|
        mod.respond_to?(:use_relative_model_naming?) && mod.use_relative_model_naming?
      end
    end
  end
end
