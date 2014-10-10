class Godmin::InstallGenerator < Rails::Generators::Base
  argument :path, type: :string

  def clean_path
    @path = @path == "." ? nil : @path
  end

  def create_initializer
    create_file build_path(@path, "config/initializers/godmin.rb") do
      <<-END.strip_heredoc
        Godmin.configure do |config|
          config.mounted_as = #{@path ? "\"#{@path}\"" : "nil"}
        end
      END
    end
  end

  def create_routes
    inject_into_file build_path(@path, "config/routes.rb"), before: /^end/ do
      <<-END.strip_heredoc.indent(2)
        godmin do
        end
      END
    end
  end

  def modify_application_controller
    inject_into_file build_path(@path, "app/controllers", @path, "application_controller.rb"), after: "ActionController::Base\n" do
      <<-END.strip_heredoc.indent(@path == nil ? 2 : 4)
        include Godmin::Application
      END
    end
  end

  def remove_layouts
    remove_dir build_path(@path, "app/views/layouts")
  end

  private

  def build_path(*parts)
    parts.compact.join("/")
  end
end
