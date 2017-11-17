require "test_helper"

module Godmin
  class EngineWrapperTest < ActiveSupport::TestCase
    module Admin
      class Engine < Rails::Engine
        isolate_namespace Admin
      end

      class Controller < ActionController::Base; end
    end

    module Admins
      class Engine < Rails::Engine
        isolate_namespace Admins
      end

      class Controller < ActionController::Base; end
    end

    class Controller < ActionController::Base; end

    def test_default_namespace
      engine_wrapper = EngineWrapper.new(Controller)
      assert_nil engine_wrapper.namespace
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
      engine_wrapper = EngineWrapper.new(Admin::Controller)
      assert_equal Admin, engine_wrapper.namespace
    end

    def test_engine_namespaced?
      engine_wrapper = EngineWrapper.new(Admin::Controller)
      assert_equal true, engine_wrapper.namespaced?
    end

    def test_engine_namespaced_path
      engine_wrapper = EngineWrapper.new(Admin::Controller)
      assert_equal ["godmin", "engine_wrapper_test", "admin"], engine_wrapper.namespaced_path
    end

    def test_plural_engine_namespaced_path
      engine_wrapper = EngineWrapper.new(Admins::Controller)
      assert_equal ["godmin", "engine_wrapper_test", "admins"], engine_wrapper.namespaced_path
    end

    def test_engine_root
      engine_wrapper = EngineWrapper.new(Admin::Controller)
      assert_equal Admin::Engine.root, engine_wrapper.root
    end
  end
end
