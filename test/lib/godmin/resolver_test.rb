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

    def test_resource_resolver_when_not_namespaced
      resolver = ResourceResolver.new("articles", EngineWrapper.new(Controller))

      assert_equal [
        File.join(Rails.application.root, "app/views/resource"),
        File.join(Godmin::Engine.root, "app/views/godmin/resource")
      ], resolver.template_paths("articles")
    end

    def test_godmin_resolver_when_not_namespaced
      resolver = GodminResolver.new("articles", EngineWrapper.new(Controller))

      assert_equal [
        File.join(Godmin::Engine.root, "app/views/godmin/shared")
      ], resolver.template_paths("shared")
    end

    def test_resource_resolver_when_namespaced
      resolver = ResourceResolver.new("godmin/resolver_test/admin/articles", EngineWrapper.new(Admin::Controller))

      assert_equal [
        File.join(Admin::Engine.root, "app/views/godmin/resolver_test/admin/resource"),
        File.join(Godmin::Engine.root, "app/views/godmin/resource")
      ], resolver.template_paths("godmin/resolver_test/admin/articles")
    end

    def test_godmin_resolver_when_namespaced
      resolver = GodminResolver.new("godmin/resolver_test/admin/articles", EngineWrapper.new(Admin::Controller))

      assert_equal [
        File.join(Godmin::Engine.root, "app/views/godmin/shared")
      ], resolver.template_paths("godmin/resolver_test/admin/shared")
    end
  end
end
