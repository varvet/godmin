require "test_helper"

module Namespace
  class ArticlePolicyTestPolicy; end
  class ObjectPolicy; end
end

class ArticlePolicyTest; extend ActiveModel::Naming; end
class OverriddenPolicyTest
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
          policy = PolicyFinder.find(ArticlePolicyTest)
          assert_equal Namespace::ArticlePolicyTestPolicy, policy
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
          policy = PolicyFinder.find(:article_policy_test)
          assert_equal Namespace::ArticlePolicyTestPolicy, policy
        end
      end

      def test_override_policy_class_on_class
        namespaced_as "namespace" do
          policy = PolicyFinder.find(OverriddenPolicyTest)
          assert_equal Namespace::ObjectPolicy, policy
        end
      end

      def test_override_policy_class_on_instance
        namespaced_as "namespace" do
          policy = PolicyFinder.find(OverriddenPolicyTest.new)
          assert_equal Namespace::ObjectPolicy, policy
        end
      end
    end
  end
end
