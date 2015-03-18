require "godmin/generators/named_base"

class Godmin::ResourceGenerator < Godmin::Generators::NamedBase
  argument :attributes, type: :array, default: [], banner: "attribute attribute"

  def add_route
    inject_into_file "config/routes.rb", after: "godmin do\n" do
      <<-END.strip_heredoc.indent(4)
        resources :#{file_name.pluralize}
      END
    end
  end

  def create_controller
    template "resource_controller.rb", File.join("app/controllers", class_path, "#{file_name.pluralize}_controller.rb")
  end

  def create_service
    template "resource_service.rb", File.join("app/services", class_path, "#{file_name}_service.rb")
  end
end
