class Godmin::AuthenticationGenerator < Rails::Generators::Base
  argument :path, type: :string
  argument :model, type: :string, default: "admin_user"

  def clean_path
    @path = @path == "." ? nil : @path
  end

  def create_model
    generate "model", "#{@model} email:string password_digest:text"
  end

  def create_route
    inject_into_file build_path(@path, "config/routes.rb"), after: "godmin do\n" do
      <<-END.strip_heredoc.indent(4)
        resource :session, only: [:new, :create, :destroy]
      END
    end
  end

  def create_sessions_controller
    create_file build_path(@path, "app/controllers", @path, "sessions_controller.rb") do
      <<-END.strip_heredoc
        class #{build_path(@path, "sessions").camelize}Controller < ApplicationController
          include Godmin::Sessions
        end
      END
    end
  end

  def modify_application_controller
    inject_into_file build_path(@path, "app/controllers", @path, "application_controller.rb"), after: "Godmin::Application\n" do
      <<-END.strip_heredoc.indent(@path == nil ? 2 : 4)
        include Godmin::Authentication

        def admin_user_class_name
          :#{@model}
        end
      END
    end
  end

  private

  def build_path(*parts)
    parts.compact.join("/")
  end
end
