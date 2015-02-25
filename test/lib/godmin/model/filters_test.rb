require "test_helper"

module Godmin
  module Model
    class FiltersTest < ActiveSupport::TestCase
      def test_calls_one_filter
        TestArticle.resources(filter: { title: "foobar" })
        assert_equal "foobar", TestArticle.called_filters[:title]
      end

      def test_calls_multiple_filters
        TestArticle.resources(filter: { title: "foobar", country: "Sweden" })
        assert_equal "foobar", TestArticle.called_filters[:title]
        assert_equal "Sweden", TestArticle.called_filters[:country]
      end

      def test_filter_map_with_default_options
        expected_filter_map = { as: :string, option_text: "to_s", option_value: "id", collection: nil }
        assert_equal expected_filter_map, TestArticle.filter_map[:title]
      end

      def test_filter_map_with_custom_options
        expected_filter_map = { as: :select, option_text: "to_s", option_value: "id", collection: %w(Sweden Canada) }
        assert_equal expected_filter_map, TestArticle.filter_map[:country]
      end
    end
  end
end
