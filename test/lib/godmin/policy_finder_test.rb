require "test_helper"

module Namespace; end
class Namespace::ArticlePolicy; end
class Namespace::ObjectPolicy; end
class Article; extend ActiveModel::Naming; end
class Overridden
  extend ActiveModel::Naming
  def self.policy_class
    Namespace::ObjectPolicy
  end

  def policy_class
    Namespace::ObjectPolicy
  end
end

module Godmin
  module Authorization
    class PolicyFinderTest < ActiveSupport::TestCase
      def test_find_by_model
        namespaced_as "namespace" do
          policy = PolicyFinder.find(Article)
          assert_equal Namespace::ArticlePolicy, policy
        end
      end

      def test_find_by_class
        namespaced_as "namespace" do
          policy = PolicyFinder.find(Object)
          assert_equal Namespace::ObjectPolicy, policy
        end
      end

      def test_find_by_symbol
        namespaced_as "namespace" do
          policy = PolicyFinder.find(:article)
          assert_equal Namespace::ArticlePolicy, policy
        end
      end

      def test_override_policy_class_on_class
        namespaced_as "namespace" do
          policy = PolicyFinder.find(Overridden)
          assert_equal Namespace::ObjectPolicy, policy
        end
      end

      def test_override_policy_class_on_instance
        namespaced_as "namespace" do
          policy = PolicyFinder.find(Overridden.new)
          assert_equal Namespace::ObjectPolicy, policy
        end
      end
    end
  end
end
