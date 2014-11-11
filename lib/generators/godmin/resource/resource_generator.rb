require "godmin/generators/base"

class Godmin::ResourceGenerator < Godmin::Generators::Base
  argument :resource, type: :string
  argument :attributes, type: :array, default: [], banner: "attribute attribute"

  def create_route
    inject_into_file "config/routes.rb", after: "godmin do\n" do
      <<-END.strip_heredoc.indent(4)
        resources :#{@resource.tableize}
      END
    end
  end

  def create_controller
    create_file ["app/controllers", "#{controller_name}.rb"].compact.join("/") do
      if namespace
        <<-END.strip_heredoc
          module #{namespace.camelize}
            class #{@resource.tableize.camelize}Controller < ApplicationController
              include Godmin::Resource

              def attrs_for_index
                #{attributes.map(&:to_sym)}
              end

              def attrs_for_form
                #{attributes.map(&:to_sym)}
              end
            end
          end
        END
      else
        <<-END.strip_heredoc
          class #{@resource.tableize.camelize}Controller < ApplicationController
            include Godmin::Resource

            def attrs_for_index
              #{attributes.map(&:to_sym)}
            end

            def attrs_for_form
              #{attributes.map(&:to_sym)}
            end
          end
        END
      end
    end
  end

  private

  def controller_name
    [namespace, "#{@resource.tableize}_controller"].compact.join("/")
  end
end
