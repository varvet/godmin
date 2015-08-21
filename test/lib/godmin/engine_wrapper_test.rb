require "test_helper"

module Godmin
  class EngineWrapperTest < ActiveSupport::TestCase
    module FooBarBaz
      class Engine < Rails::Engine
        isolate_namespace FooBarBaz
      end

      class Controller < ActionController::Base; end
    end

    class Controller < ActionController::Base; end

    def test_default_namespace
      engine_wrapper = EngineWrapper.new(Controller)
      assert_equal nil, engine_wrapper.namespace
    end

    def test_default_namespaced?
      engine_wrapper = EngineWrapper.new(Controller)
      assert_equal false, engine_wrapper.namespaced?
    end

    def test_default_namespaced_path
      engine_wrapper = EngineWrapper.new(Controller)
      assert_equal [], engine_wrapper.namespaced_path
    end

    def test_default_root
      engine_wrapper = EngineWrapper.new(Controller)
      assert_equal Rails.application.root, engine_wrapper.root
    end

    def test_engine_namespace
      engine_wrapper = EngineWrapper.new(FooBarBaz::Controller)
      assert_equal FooBarBaz, engine_wrapper.namespace
    end

    def test_engine_namespaced?
      engine_wrapper = EngineWrapper.new(FooBarBaz::Controller)
      assert_equal true, engine_wrapper.namespaced?
    end

    def test_engine_namespaced_path
      engine_wrapper = EngineWrapper.new(FooBarBaz::Controller)
      assert_equal ["godmin", "engine_wrapper_test", "foo_bar_baz"], engine_wrapper.namespaced_path
    end

    def test_engine_root
      engine_wrapper = EngineWrapper.new(FooBarBaz::Controller)
      assert_equal FooBarBaz::Engine.root, engine_wrapper.root
    end
  end
end
