require "test_helper"

module Godmin
  module ResourceService
    class PaginationTest < ActiveSupport::TestCase
      def setup
        @article_service = Fakes::ArticleService.new

        resources_class = Class.new do
          def limit(_limit_param)
            self
          end

          def offset(_offset_param)
            self
          end
        end

        @resources = resources_class.new
      end

      def test_paginator_is_set_correctly
        @article_service.apply_pagination(1, @resources)

        assert_kind_of Paginator, @article_service.paginator
        assert_equal   1,         @article_service.paginator.current_page
        assert_equal   25,        @article_service.paginator.per_page
      end
    end
  end
end
