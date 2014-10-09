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
    def setup
      @foo_resolver = FooResolver.new("controller_name")
      @bar_resolver = BarResolver.new("controller_name")
    end

    def test_foo_resolver_template_paths_no_partial
      mounted_as "admin" do
        assert_equal @foo_resolver.template_paths("prefix", false), [
          "admin/controller_name/prefix",
          "admin/controller_name",
          "admin/prefix",
          "admin/resource/prefix",
          "admin/resource",
          "admin"
        ]
      end
    end

    def test_foo_resolver_template_paths_partial
      mounted_as "admin" do
        assert_equal @foo_resolver.template_paths("prefix", false), [
          "admin/controller_name/prefix",
          "admin/controller_name",
          "admin/prefix",
          "admin/resource/prefix",
          "admin/resource",
          "admin"
        ]
      end
    end

    def test_bar_resolver_template_paths_no_partial
      mounted_as "admin" do
        assert_equal @bar_resolver.template_paths("prefix", false), [
          "godmin/controller_name/prefix",
          "godmin/controller_name",
          "godmin/prefix",
          "godmin/resource/prefix",
          "godmin/resource",
          "godmin"
        ]
      end
    end

    def test_bar_resolver_template_paths_partial
      mounted_as "admin" do
        assert_equal @bar_resolver.template_paths("prefix", false), [
          "godmin/controller_name/prefix",
          "godmin/controller_name",
          "godmin/prefix",
          "godmin/resource/prefix",
          "godmin/resource",
          "godmin"
        ]
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
