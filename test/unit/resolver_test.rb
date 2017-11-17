require "test_helper"

module Godmin
  class ResolverTest < ActiveSupport::TestCase
    module Admin
      class Engine < Rails::Engine
        isolate_namespace Admin
      end

      class Controller < ActionController::Base; end
    end

    class Controller < ActionController::Base; end

    def setup
      @engine_wrapper_1 = EngineWrapper.new(Controller)
      @engine_wrapper_2 = EngineWrapper.new(Admin::Controller)
    end

    def test_engine_resolver_when_not_namespaced
      resolver = EngineResolver.new("articles", @engine_wrapper_1)

      assert_equal [
        "resource"
      ], resolver.template_paths("articles")
    end

    def test_engine_resolver_when_namespaced
      resolver = EngineResolver.new("godmin/resolver_test/admin/articles", @engine_wrapper_2)

      assert_equal [
        "godmin/resolver_test/admin/resource"
      ], resolver.template_paths("godmin/resolver_test/admin/articles")
    end

    def test_godmin_resolver_when_not_namespaced
      resolver = GodminResolver.new("articles", @engine_wrapper_1)

      assert_equal [
        "articles",
        "resource"
      ], resolver.template_paths("articles")
    end

    def test_godmin_resolver_when_namespaced
      resolver = GodminResolver.new("godmin/resolver_test/admin/articles", @engine_wrapper_2)

      assert_equal [
        "articles",
        "resource"
      ], resolver.template_paths("godmin/resolver_test/admin/articles")
    end
  end
end
