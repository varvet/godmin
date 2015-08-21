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

    def test_godmin_resolver_when_not_namespaced
      resolver = GodminResolver.new("articles", @engine_wrapper_1)

      assert_equal [
        File.join(@engine_wrapper_1.root, "app/views/resource"),
        File.join(Godmin::Engine.root, "app/views/godmin/resource"),
        File.join(Godmin::Engine.root, "app/views/godmin/articles")
      ], resolver.template_paths("articles")
    end

    def test_godmin_resolver_when_namespaced
      resolver = GodminResolver.new("godmin/resolver_test/admin/articles", @engine_wrapper_2)

      assert_equal [
        File.join(@engine_wrapper_2.root, "app/views/godmin/resolver_test/admin/resource"),
        File.join(Godmin::Engine.root, "app/views/godmin/resource"),
        File.join(Godmin::Engine.root, "app/views/godmin/articles")
      ], resolver.template_paths("godmin/resolver_test/admin/articles")
    end

    # def test_resource_resolver_when_not_namespaced
    #   resolver = ResourceResolver.new("articles", @engine_wrapper_1)
    #
    #   assert_equal [
    #     File.join(@engine_wrapper_1.root, "app/views/resource"),
    #     File.join(Godmin::Engine.root, "app/views/godmin/resource")
    #   ], resolver.template_paths("articles")
    # end

    # def test_godmin_resolver_when_not_namespaced
    #   resolver = GodminResolver.new("articles", @engine_wrapper_1)
    #
    #   assert_equal [
    #     File.join(Godmin::Engine.root, "app/views/godmin/shared")
    #   ], resolver.template_paths("shared")
    # end

    # def test_resource_resolver_when_namespaced
    #   resolver = ResourceResolver.new("godmin/resolver_test/admin/articles", @engine_wrapper_2)
    #
    #   assert_equal [
    #     File.join(@engine_wrapper_2.root, "app/views/godmin/resolver_test/admin/resource"),
    #     File.join(Godmin::Engine.root, "app/views/godmin/resource")
    #   ], resolver.template_paths("godmin/resolver_test/admin/articles")
    # end

    # def test_godmin_resolver_when_namespaced
    #   resolver = GodminResolver.new("godmin/resolver_test/admin/articles", @engine_wrapper_2)
    #
    #   assert_equal [
    #     File.join(Godmin::Engine.root, "app/views/godmin/shared")
    #   ], resolver.template_paths("godmin/resolver_test/admin/shared")
    # end
  end
end
