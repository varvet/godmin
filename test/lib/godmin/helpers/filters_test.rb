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

      # TODO: actually implement this test properly, apparently
      # assert_select can be used if the helper output is parsed
      # with HTML::Document first...
      def test_string_filter_field
        form = filter_form url: "/" do |f|
          f.filter_field :foo, as: :string
        end
      end
    end
  end
end
