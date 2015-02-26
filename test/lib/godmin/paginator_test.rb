require "test_helper"

module Godmin
  class PaginatorTest < ActiveSupport::TestCase
    def setup
      resources_class = Class.new do
        attr_reader :limit_param
        attr_reader :offset_param

        def count
          50
        end

        def limit(limit_param)
          @limit_param = limit_param
          self
        end

        def offset(offset_param)
          @offset_param = offset_param
          self
        end
      end

      @resources = resources_class.new
    end

    def test_paginate
      paginator = Paginator.new(10, 1, @resources)

      assert_equal @resources, paginator.paginate
      assert_equal 10, @resources.limit_param
      assert_equal 0, @resources.offset_param
    end

    def test_paginate_with_offset
      paginator = Paginator.new(10, 2, @resources)

      assert_equal @resources, paginator.paginate
      assert_equal 10, @resources.limit_param
      assert_equal 10, @resources.offset_param
    end

    def test_current_page
      paginator = Paginator.new(nil, 2, nil)
      assert_equal 2, paginator.current_page
    end

    def test_current_page_when_no_page
      paginator = Paginator.new(nil, nil, nil)
      assert_equal 1, paginator.current_page
    end

    def test_pages_when_pages_all_fit
      paginator = Paginator.new(10, 1, @resources)
      assert_equal [1, 2, 3, 4, 5], paginator.pages
    end

    def test_pages_when_pages_dont_fit_and_on_first_page
      paginator = Paginator.new(2, 1, @resources)
      assert_equal [1, 2, 3, 4, 5, 6, 7], paginator.pages
    end

    def test_pages_when_pages_dont_fit_and_on_middle_page
      paginator = Paginator.new(2, 7, @resources)
      assert_equal [4, 5, 6, 7, 8, 9, 10], paginator.pages
    end

    def test_pages_when_pages_dont_fit_and_on_last_page
      paginator = Paginator.new(2, 25, @resources)
      assert_equal [19, 20, 21, 22, 23, 24, 25], paginator.pages
    end

    def test_total_pages
      paginator = Paginator.new(10, nil, @resources)
      assert_equal 5, paginator.total_pages
    end

    def test_total_resources
      paginator = Paginator.new(nil, nil, @resources)
      assert_equal 50, paginator.total_resources
    end
  end
end
