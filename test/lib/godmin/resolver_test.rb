require "test_helper"

module Godmin
  class ResolverTest < ActiveSupport::TestCase
    def test_engine_resolver_template_paths
      namespaced_as "namespace" do
        assert_equal [
          "namespace/controller_name/prefix",
          "namespace/controller_name",
          "namespace/prefix",
          "namespace/resource/prefix",
          "namespace/resource",
          "namespace"
        ], EngineResolver.new("controller_name").template_paths("prefix", false)
      end
    end

    def test_engine_resolver_template_paths_when_namespace_is_in_prefix
      namespaced_as "namespace" do
        assert_equal [
          "namespace/controller_name/prefix",
          "namespace/controller_name",
          "namespace/prefix",
          "namespace/resource/prefix",
          "namespace/resource",
          "namespace"
        ], EngineResolver.new("controller_name").template_paths("namespace/prefix", false)
      end
    end

    def test_godmin_resolver_template_paths
      namespaced_as "namespace" do
        assert_equal [
          "godmin/controller_name/prefix",
          "godmin/controller_name",
          "godmin/prefix",
          "godmin/resource/prefix",
          "godmin/resource",
          "godmin"
        ], GodminResolver.new("controller_name").template_paths("prefix", false)
      end
    end
  end
end
