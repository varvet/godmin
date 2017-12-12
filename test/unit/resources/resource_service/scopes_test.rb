require "test_helper"

module Godmin
  module ResourceService
    class ScopesTest < ActiveSupport::TestCase
      def setup
        @article_service = Fakes::ArticleService.new
      end

      def test_returns_resources_when_no_scopes_are_defined
        service_class = Class.new do
          include Godmin::Resources::ResourceService
        end

        service = service_class.new
        assert_equal :resources, service.apply_scope("", :resources)
      end

      def test_calls_default_scope
        @article_service.apply_scope("", :resources)
        assert_equal :resources, @article_service.called_methods[:scopes][:unpublished]
      end

      def test_calls_non_default_scope
        @article_service.apply_scope("published", :resources)
        assert_equal :resources, @article_service.called_methods[:scopes][:published]
      end

      def test_calls_unimplemented_scope
        assert_raises NotImplementedError do
          @article_service.apply_scope("trashed", :resources)
        end
      end

      def test_current_scope
        @article_service.apply_scope("", :resources)
        assert_equal "unpublished", @article_service.scope
      end

      def test_currently_scoped_by
        @article_service.apply_scope("", :resources)
        assert     @article_service.scoped_by?("unpublished")
        assert_not @article_service.scoped_by?("published")
      end

      def test_scope_count
        assert_equal 2, @article_service.scope_count("unpublished")
        assert_equal 1, @article_service.scope_count("published")
      end

      def test_scope_map
        assert_equal({ default: true }, @article_service.scope_map[:unpublished])
        assert_equal({ default: false }, @article_service.scope_map[:published])
      end
    end
  end
end
