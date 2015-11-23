require "godmin/generators/named_base"

class Godmin::AuthenticationGenerator < Godmin::Generators::NamedBase
  argument :name, type: :string, default: "admin_user"

  def create_model
    generate "model", "#{name} email:string password_digest:text --no-test-framework"
  end

  def modify_model
    inject_into_file File.join("app/models", class_path, "#{file_name}.rb"), after: "ActiveRecord::Base\n" do
      <<-END.strip_heredoc.indent(namespace ? 4 : 2)
        include Godmin::Authentication::User

        def self.login_column
          :email
        end
      END
    end
  end

  def create_route
    route "resource :session, only: [:new, :create, :destroy]"
  end

  def create_sessions_controller
    template "sessions_controller.rb", File.join("app/controllers", namespaced_path, "sessions_controller.rb")
  end

  def modify_application_controller
    inject_into_file File.join("app/controllers", namespaced_path, "application_controller.rb"), after: "Godmin::ApplicationController\n" do
      <<-END.strip_heredoc.indent(namespace ? 4 : 2)
        include Godmin::Authentication

        def admin_user_class
          #{full_class_name}
        end
      END
    end
  end
end
