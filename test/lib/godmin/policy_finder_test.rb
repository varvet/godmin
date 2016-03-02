# require "test_helper"
#
# module Godmin
#   module Authorization
#     class PolicyFinderTest < ActiveSupport::TestCase
#       class Article; end
#       class ArticlePolicy; end
#
#       def test_find_by_model
#         klass = Class.new do
#           extend ActiveModel::Naming
#
#           def self.name
#             "Article"
#           end
#         end
#
#         policy = PolicyFinder.find(klass, Godmin::Authorization::PolicyFinderTest)
#         assert_equal ArticlePolicy, policy
#       end
#
#       def test_find_by_class
#         policy = PolicyFinder.find(Article)
#         assert_equal ArticlePolicy, policy
#       end
#
#       def test_find_by_symbol
#         policy = PolicyFinder.find(:article, Godmin::Authorization::PolicyFinderTest)
#         assert_equal ArticlePolicy, policy
#       end
#
#       def test_override_policy_class_on_class
#         klass = Class.new do
#           def self.policy_class
#             ArticlePolicy
#           end
#         end
#
#         policy = PolicyFinder.find(klass)
#         assert_equal ArticlePolicy, policy
#       end
#
#       def test_override_policy_class_on_instance
#         klass = Class.new do
#           def policy_class
#             ArticlePolicy
#           end
#         end
#
#         policy = PolicyFinder.find(klass.new)
#         assert_equal ArticlePolicy, policy
#       end
#     end
#   end
# end
