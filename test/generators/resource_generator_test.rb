require "test_helper"
require "generators/godmin/resource/resource_generator"

module Godmin
  class ResourceGeneratorTest < ::Rails::Generators::TestCase
    tests ResourceGenerator
    destination File.expand_path("../../tmp", __FILE__)
    setup :prepare_destination

    def test_resource_generator_in_standalone_install
      system "cd test/tmp && rails new . --skip-test --skip-spring --skip-bundle --skip-git --quiet"
      system "cd test/tmp && rails generate godmin:install --quiet"

      run_generator %w[foo bar]

      assert_file "config/routes.rb", /resources :foos/

      assert_file "app/views/shared/_navigation.html.erb", /<%= navbar_item Foo %>/

      assert_file "app/controllers/foos_controller.rb" do |content|
        expected_content = <<-CONTENT.strip_heredoc
          class FoosController < ApplicationController
            include Godmin::Resources::ResourceController
          end
        CONTENT
        assert_match expected_content, content
      end

      assert_file "app/services/foo_service.rb" do |content|
        expected_content = <<-CONTENT.strip_heredoc
          class FooService
            include Godmin::Resources::ResourceService

            attrs_for_index :bar
            attrs_for_show :bar
            attrs_for_form :bar
          end
        CONTENT
        assert_match expected_content, content
      end
    end

    def test_resource_generator_in_engine_install
    end
  end
end
