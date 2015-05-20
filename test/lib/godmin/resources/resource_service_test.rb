require "test_helper"

module Godmin
  class ResourceServiceTest < ActiveSupport::TestCase
    def setup
      @article_service = ArticleService.new
    end

    def test_resource_class
      assert_equal Article, @article_service.resource_class
    end

    def test_attrs_for_index
      assert_equal [:id, :title, :country], @article_service.attrs_for_index
    end

    def test_attrs_for_show
      assert_equal [:title, :country], @article_service.attrs_for_show
    end

    def test_attrs_for_form
      assert_equal [:id, :title, :country, :body], @article_service.attrs_for_form
    end

    def test_attrs_for_export
      assert_equal [:id, :title], @article_service.attrs_for_export
    end
  end
end
