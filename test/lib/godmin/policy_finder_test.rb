require "test_helper"

class Article; extend ActiveModel::Naming; end

module Godmin
  class PolicyFinderTest < ActiveSupport::TestCase
    def test_find_by_model
      mounted_as "namespace" do
        policy = PolicyFinder.find(Article)
        assert_equal "Namespace::ArticlePolicy", policy
      end
    end

    def test_find_by_class
      mounted_as "namespace" do
        policy = PolicyFinder.find(Object)
        assert_equal "Namespace::ObjectPolicy", policy
      end
    end

    def test_find_by_symbol
      mounted_as "namespace" do
        policy = PolicyFinder.find(:article)
        assert_equal "Namespace::ArticlePolicy", policy
      end
    end
  end
end
