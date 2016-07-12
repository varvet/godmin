require "test_helper"

module Godmin
  module ResourceService
    class BatchActionsTest < ActiveSupport::TestCase
      def setup
        @article_service = Fakes::ArticleService.new
      end

      def test_batch_action
        assert @article_service.batch_action(:unpublish, [:foo, :bar])
        assert_equal [:foo, :bar], @article_service.called_methods[:batch_actions][:unpublish]
      end

      def test_batch_action_when_it_does_not_exist
        assert_not @article_service.batch_action(:foobar, [:foo, :bar])
        assert_equal nil, @article_service.called_methods[:batch_actions][:foobar]
      end

      def test_batch_action_exists
        assert @article_service.batch_action?(:unpublish)
      end

      def test_batch_action_does_not_exist
        assert_not @article_service.batch_action?(:foobar)
      end

      def test_batch_action_map_with_default_options
        expected_batch_action_map = { only: nil, except: nil, confirm: false }
        assert_equal expected_batch_action_map, @article_service.batch_action_map[:unpublish]
      end

      def test_batch_action_map_with_custom_options
        expected_batch_action_map = { only: [:unpublished], except: [:published], confirm: true }
        assert_equal expected_batch_action_map, @article_service.batch_action_map[:publish]
      end
    end
  end
end
