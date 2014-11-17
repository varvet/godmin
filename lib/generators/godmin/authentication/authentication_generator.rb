require "godmin/generators/base"

class Godmin::AuthenticationGenerator < Godmin::Generators::Base
  argument :model, type: :string, default: "admin_user"

  def create_model
    generate "model", "#{@model} email:string password_digest:text --no-test-framework"
  end

  def modify_model
    inject_into_file ["app/models", namespace, "#{@model.underscore}.rb"].compact.join("/"), after: "ActiveRecord::Base\n" do
      <<-END.strip_heredoc.indent(namespace.nil? ? 2 : 4)
        include Godmin::Authentication::User

        def self.login_column
          :email
        end
      END
    end
  end

  def create_route
    inject_into_file "config/routes.rb", after: "godmin do\n" do
      <<-END.strip_heredoc.indent(4)
        resource :session, only: [:new, :create, :destroy]
      END
    end
  end

  def create_sessions_controller
    create_file ["app/controllers", namespace, "sessions_controller.rb"].compact.join("/") do
      if namespace
        <<-END.strip_heredoc
          module #{namespace.camelize}
            class SessionsController < ApplicationController
              include Godmin::Authentication::Sessions
            end
          end
        END
      else
        <<-END.strip_heredoc
          class SessionsController < ApplicationController
            include Godmin::Authentication::Sessions
          end
        END
      end
    end
  end

  def modify_application_controller
    inject_into_file ["app/controllers", namespace, "application_controller.rb"].compact.join("/"), after: "Godmin::Application\n" do
      <<-END.strip_heredoc.indent(namespace.nil? ? 2 : 4)
        include Godmin::Authentication

        def admin_user_class
          #{[namespace, @model.underscore].compact.join("/").camelize}
        end
      END
    end
  end
end
