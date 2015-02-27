require "test_helper"

module Godmin
  class ModelTest < ActiveSupport::TestCase
    def setup
      @article_thing = ArticleThing.new
    end

    def test_responds_to_resources
      assert @article_thing.respond_to?(:resources)
    end

    def test_attrs_for_index
      assert_equal [:id, :title, :country], @article_thing.attrs_for_index
    end

    def test_attrs_for_form
      assert_equal [:id, :title, :country, :body], @article_thing.attrs_for_form
    end
  end
end
