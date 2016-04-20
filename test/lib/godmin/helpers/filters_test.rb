require "test_helper"

module Godmin
  module Helpers
    class FiltersTest < ActionView::TestCase
      include BootstrapForm::Helper
      include Godmin::Helpers::Filters
      include Godmin::Helpers::Translations

      def test_filter_form_is_a_bootstrap_form_builder
        filter_form url: "/" do |f|
          assert f.is_a? BootstrapForm::FormBuilder
        end
      end

      def test_string_renders_as_string
        @output_buffer = filter_form url: "/" do |f|
          f.filter_field :foo, as: :string
        end

        assert_select "input[type=text][name=?]", "filter[foo]", 1, "No text input found with name foo"
      end

      def test_string_filter_field_renders_text_field
        @output_buffer = filter_form url: "/" do |f|
          f.string_filter_field :foo, {}, value: "Foobar"
        end

        assert_select "label[for=foo]", 1, "No label was found"
        assert_select "input[type=text][name=?]", "filter[foo]", 1, "No text input found with name foo" do |element|
          assert_equal "Foo", element.attr("placeholder").text
          assert_equal "Foobar", element.attr("value").text
        end
      end

      def test_multiselect_filter_field_includes_no_hidden
        @output_buffer = filter_form url: "/" do |f|
          f.multiselect_filter_field :foo, collection: -> { %w(Foo Bar) }
        end

        assert_select "label[for=foo]", 1, "No label was found"
        assert_select "select[name=?]", "filter[foo][]", 1, "No text input found with name foo" do
          assert_select "option", 3
        end
        assert_select "input[type=hidden][name=?]", "filter[foo][]", 0
      end
    end
  end
end
