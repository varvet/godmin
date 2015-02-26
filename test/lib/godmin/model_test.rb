require "test_helper"

module Godmin
  class ModelTest < ActiveSupport::TestCase
    def test_responds_to_resources
      assert ArticleThing.new.respond_to?(:resources)
    end
  end
end
