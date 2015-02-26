require "test_helper"

module Godmin
  module Model
    class ScopesTest < ActiveSupport::TestCase
      def setup
        @article_thing = ArticleThing.new
      end

      def test_calls_default_scope
        @article_thing.apply_scope("", :resources)
        assert_equal :resources, @article_thing.called_methods[:scopes][:unpublished]
      end

      def test_calls_non_default_scope
        @article_thing.apply_scope("published", :resources)
        assert_equal :resources, @article_thing.called_methods[:scopes][:published]
      end

      def test_calls_unimplemented_scope
        assert_raises NotImplementedError do
          @article_thing.apply_scope("trashed", :resources)
        end
      end

      def test_current_scope
        @article_thing.apply_scope("", :resources)
        assert_equal "unpublished", @article_thing.scope
      end

      def test_currently_scoped_by
        @article_thing.apply_scope("", :resources)
        assert     @article_thing.scoped_by?("unpublished")
        assert_not @article_thing.scoped_by?("published")
      end

      def test_scope_count
        assert_equal 2, @article_thing.scope_count("unpublished")
        assert_equal 1, @article_thing.scope_count("published")
      end

      def test_scope_map
        assert_equal({ default: true }, @article_thing.scope_map[:unpublished])
        assert_equal({ default: false }, @article_thing.scope_map[:published])
      end
    end
  end
end
