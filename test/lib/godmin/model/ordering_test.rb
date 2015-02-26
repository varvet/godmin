require "test_helper"

module Godmin
  module Model

    class OrderingTest < ActiveSupport::TestCase
      def setup
        @article_thing = ArticleThing.new
      end

      def test_apply_order
        resources_class = Class.new do
          attr_reader :order_param

          def order(order_param)
            @order_param = order_param
          end
        end

        resources = resources_class.new

        @article_thing.apply_order("title_desc", resources)
        assert_equal "title_desc", resources.order_param
      end
    end
  end
end
