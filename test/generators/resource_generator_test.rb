require "test_helper"
require "generators/godmin/resource/resource_generator"

module Godmin
  class ResourceGeneratorTest < ::Rails::Generators::TestCase
    tests ResourceGenerator
    destination File.expand_path("../../tmp", __FILE__)
    setup :prepare_destination

    def test_something
      system "cd test/tmp && rails new . --skip-test --skip-spring --skip-bundle --skip-git --skip-keeps --quiet"
      system "cd test/tmp && rails generate godmin:install --quiet"

      run_generator %w[foo]
    end
  end
end
