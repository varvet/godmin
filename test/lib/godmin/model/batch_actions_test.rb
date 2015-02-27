require "test_helper"

module Godmin
  module Model
    class BatchActionsTest < ActiveSupport::TestCase
      def setup
        resource_class = Class.new do
          def self.find(ids)
            ids
          end
        end

        @article_thing = ArticleThing.new(resource_class)
      end

      def test_batch_action
        assert @article_thing.batch_action(:unpublish, [:foo, :bar])
        assert_equal [:foo, :bar], @article_thing.called_methods[:batch_actions][:unpublish]
      end

      def test_batch_action_when_it_does_not_exist
        assert_not @article_thing.batch_action(:foobar, [:foo, :bar])
        assert_equal nil, @article_thing.called_methods[:batch_actions][:foobar]
      end

      def test_batch_action_exists
        assert @article_thing.batch_action?(:unpublish)
      end

      def test_batch_action_does_not_exist
        assert_not @article_thing.batch_action?(:foobar)
      end

      def test_batch_action_map_with_default_options
        expected_batch_action_map = { only: nil, except: nil, confirm: false }
        assert_equal expected_batch_action_map, @article_thing.batch_action_map[:unpublish]
      end

      def test_batch_action_map_with_custom_options
        expected_batch_action_map = { only: :unpublished, except: :published, confirm: true }
        assert_equal expected_batch_action_map, @article_thing.batch_action_map[:publish]
      end
    end
  end
end
