require "test_helper"
require "generators/godmin/resource/resource_generator"

module Godmin
  class ResourceGeneratorTest < ::Rails::Generators::TestCase
    tests ResourceGenerator
    destination File.expand_path("../../tmp", __FILE__)
    setup :prepare_destination
    teardown :prepare_destination

    def test_resource_generator_in_standalone_install
      system "cd #{destination_root} && rails new . --skip-test --skip-spring --skip-bundle --skip-git --quiet"
      system "cd #{destination_root} && bin/rails generate godmin:install --quiet"
      system "cd #{destination_root} && bin/rails generate godmin:resource foo bar --quiet"

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
      system "cd #{destination_root} && rails new . --skip-test --skip-spring --skip-bundle --skip-git --quiet"
      system "cd #{destination_root} && bin/rails plugin new fakemin --mountable --quiet"
      system "cd #{destination_root} && fakemin/bin/rails generate godmin:install --quiet"
      system "cd #{destination_root} && fakemin/bin/rails generate godmin:resource foo bar --quiet"

      assert_file "fakemin/config/routes.rb", /resources :foos/
      assert_file "fakemin/app/views/fakemin/shared/_navigation.html.erb", /<%= navbar_item Foo %>/

      assert_file "fakemin/app/controllers/fakemin/foos_controller.rb" do |content|
        expected_content = <<-CONTENT.strip_heredoc
          module Fakemin
            class FoosController < ApplicationController
              include Godmin::Resources::ResourceController
            end
          end
        CONTENT
        assert_match expected_content, content
      end

      assert_file "fakemin/app/services/fakemin/foo_service.rb" do |content|
        expected_content = <<-CONTENT.strip_heredoc
          module Fakemin
            class FooService
              include Godmin::Resources::ResourceService

              attrs_for_index :bar
              attrs_for_show :bar
              attrs_for_form :bar
            end
          end
        CONTENT
        assert_match expected_content, content
      end
    end
  end
end
