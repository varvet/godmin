require "test_helper"

module Godmin
  module ResourceService
    class OrderingTest < ActiveSupport::TestCase
      def setup
        resource_class = Class.new do
          def self.table_name
            "articles"
          end
        end

        @resources_class = Class.new do
          attr_reader :order_param

          def order(order_param)
            @order_param = order_param
          end
        end

        @article_service = ArticleService.new(resource_class)
      end

      def test_apply_order
        resources = @resources_class.new
        @article_service.apply_order("title_desc", resources)
        assert_equal "articles.title desc", resources.order_param
      end

      def test_apply_order_without_order
        resources = @resources_class.new
        @article_service.apply_order("", resources)
        assert_equal nil, resources.order_param
      end
    end
  end
end
