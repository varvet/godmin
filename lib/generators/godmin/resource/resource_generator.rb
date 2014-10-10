class Godmin::ResourceGenerator < Rails::Generators::Base
  argument :path, type: :string
  argument :resource, type: :string
  argument :attributes, type: :array, default: [], banner: "attribute attribute"

  def clean_path
    @path = @path == "." ? nil : @path
  end

  def create_route
    inject_into_file build_path(@path, "config/routes.rb"), after: "godmin do\n" do
      <<-END.strip_heredoc.indent(4)
        resources :#{@resource.tableize}
      END
    end
  end

  def create_controller
    create_file build_path(@path, "app/controllers", @path, "#{@resource.tableize}_controller.rb") do
      <<-END.strip_heredoc
        class #{build_path(@path, @resource.tableize).camelize}Controller < ApplicationController
          include Godmin::Resource

          # concerning :Scopes do
          #   included do
          #     scope :foo
          #   end
          #
          #   private
          #
          #   def scope_foo(#{@resource.tableize})
          #     #{@resource.tableize}.where(condition: true)
          #   end
          # end
          #
          # concerning :Filters do
          #   included do
          #     filter :foo
          #   end
          #
          #   private
          #
          #   def filter_foo(#{@resource.tableize}, value)
          #     #{@resource.tableize}.where(condition: value)
          #   end
          # end
          #
          # concerning :BatchActions do
          #   included do
          #     batch_action :foo, confirm: true
          #   end
          #
          #   private
          #
          #   def batch_action_foo(#{@resource.tableize})
          #     #{@resource.tableize}.each do |#{@resource.tableize[0]}|
          #       #{@resource.tableize[0]}.update_attributes(condition: true)
          #     end
          #   end
          # end

          def attrs_for_index
            #{attributes.map(&:to_sym).to_s}
          end

          def attrs_for_form
            #{attributes.map(&:to_sym).to_s}
          end
        end
      END
    end
  end

  private

  def build_path(*parts)
    parts.compact.join("/")
  end
end
