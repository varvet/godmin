require "godmin/generators/base"

class Godmin::InstallGenerator < Godmin::Generators::Base
  def create_initializer
    create_file "config/initializers/godmin.rb" do
      <<-END.strip_heredoc
        Godmin.configure do |config|
          config.namespace = #{namespace ? "\"#{namespaced_path.join("/")}\"" : "nil"}
        end
      END
    end
  end

  def create_routes
    inject_into_file "config/routes.rb", before: /^end/ do
      <<-END.strip_heredoc.indent(2)
        godmin do
        end
      END
    end
  end

  def modify_application_controller
    inject_into_file File.join("app/controllers", namespaced_path, "application_controller.rb"), after: "ActionController::Base\n" do
      <<-END.strip_heredoc.indent(namespace ? 4 : 2)
        include Godmin::Application
      END
    end
  end

  def modify_application_js
    inject_into_file File.join("app/assets/javascripts", namespaced_path, "application.js"), before: "//= require_tree ." do
      "//= require godmin\n"
    end
  end

  def modify_application_css
    inject_into_file File.join("app/assets/stylesheets", namespaced_path, "application.css"), before: " *= require_tree ." do
      " *= require godmin\n"
    end
  end

  def require_library_if_namespaced
    return unless namespaced?

    inject_into_file File.join("lib", namespaced_path) + ".rb", before: "require" do
      <<-END.strip_heredoc
        require "godmin"
      END
    end
  end

  def remove_layouts
    remove_dir "app/views/layouts"
  end
end
