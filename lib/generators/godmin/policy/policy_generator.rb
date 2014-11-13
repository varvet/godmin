require "godmin/generators/base"

class Godmin::PolicyGenerator < Godmin::Generators::Base
  argument :resource, type: :string

  def create_controller
    create_file ["app/policies", "#{policy_name}.rb"].compact.join("/") do
      if namespace
        <<-END.strip_heredoc
          module #{namespace.camelize}
            class #{@resource.underscore.camelize}Policy < Godmin::Policy
            end
          end
        END
      else
        <<-END.strip_heredoc
          class #{@resource.underscore.camelize}Policy < Godmin::Policy
          end
        END
      end
    end
  end

  private

  def policy_name
    [namespace, "#{@resource.underscore}_policy"].compact.join("/")
  end
end
