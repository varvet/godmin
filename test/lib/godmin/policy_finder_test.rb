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
        policy = PolicyFinder.find(ArticlePolicyTest, "namespace")
        assert_equal Namespace::ArticlePolicyTestPolicy, policy
      end

      def test_find_by_class
        policy = PolicyFinder.find(Object, "namespace")
        assert_equal Namespace::ObjectPolicy, policy
      end

      def test_find_by_symbol
        policy = PolicyFinder.find(:article_policy_test, "namespace")
        assert_equal Namespace::ArticlePolicyTestPolicy, policy
      end

      def test_override_policy_class_on_class
        policy = PolicyFinder.find(OverriddenPolicyTest, "namespace")
        assert_equal Namespace::ObjectPolicy, policy
      end

      def test_override_policy_class_on_instance
        policy = PolicyFinder.find(OverriddenPolicyTest.new, "namespace")
        assert_equal Namespace::ObjectPolicy, policy
      end
    end
  end
end
