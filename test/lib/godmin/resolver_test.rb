# 1. name: index; prefix: admin/articles OR articles
#
#    admin/articles/admin/articles | admin/articles/articles < controller name + prefix !PARTIAL
#    admin/articles < controller name
#    admin/admin/articles | admin/articles < prefix !PARTIAL
#    admin/resource/admin/articles | admin/resource/articles < resource + prefix !PARTIAL
#    admin/resource
#    admin
#
# 2. name: navigation; prefix: shared
#
#    admin/articles/shared < controller name + prefix
#    admin/articles < controller name
#    admin/shared < prefix
#    admin/resource/shared < resource + prefix
#    admin/resource
#    admin
#
# 3. name: title; prefix: columns
#
#    admin/articles/columns < controller name + prefix
#    admin/articles < controller name
#    admin/columns < prefix
#    admin/resource/columns < resource + prefix
#    admin/resource < resource
#    admin

require "test_helper"

module Godmin
  class ResolverTest < ActiveSupport::TestCase
    def test_foo_resolver_template_paths
      mounted_as "namespace" do
        assert_equal [
          "namespace/controller_name/prefix",
          "namespace/controller_name",
          "namespace/prefix",
          "namespace/resource/prefix",
          "namespace/resource",
          "namespace"
        ], FooResolver.new("controller_name").template_paths("prefix", false)
      end
    end

    def test_bar_resolver_template_paths
      mounted_as "namespace" do
        assert_equal [
          "godmin/controller_name/prefix",
          "godmin/controller_name",
          "godmin/prefix",
          "godmin/resource/prefix",
          "godmin/resource",
          "godmin"
        ], BarResolver.new("controller_name").template_paths("prefix", false)
      end
    end

    private

    def mounted_as(namespace)
      Godmin.mounted_as = namespace
      yield
      Godmin.mounted_as = nil
    end
  end
end
