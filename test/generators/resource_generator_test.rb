require "test_helper"
require "generators/godmin/resource/resource_generator"

module Godmin
  class ResourceGeneratorTest < ::Rails::Generators::TestCase
    tests ResourceGenerator
    destination File.expand_path("../../tmp", __FILE__)
    setup :prepare_destination

    def test_something
      binding.pry
      # FileUtils.cp_r File.expand_path("../../../../dummy", __FILE__), File.expand_path("../../../../tmp", __FILE__)
      # run_generator %w[foo]
    end
  end
end
