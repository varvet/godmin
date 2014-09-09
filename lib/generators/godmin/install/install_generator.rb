class Godmin::InstallGenerator < Rails::Generators::Base
  argument :path, type: :string

  def clean_path
    @path = @path == "." ? nil : @path
  end

  # TODO: mounted as should probably not be a dot
  def create_initializer
    create_file build_path(@path, "config/initializers/godmin.rb") do
      <<-END.strip_heredoc
        Godmin.configure do |config|
          config.mounted_as = #{@path ? @path.to_sym : "nil"}
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

  def create_controller
    gsub_file build_path(@path, "app/controllers", @path, "application_controller.rb"), "ActionController::Base" do
      "Godmin::ApplicationController"
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
