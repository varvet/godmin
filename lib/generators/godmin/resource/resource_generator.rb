require "godmin/generators/named_base"

class Godmin::ResourceGenerator < Godmin::Generators::NamedBase
  argument :attributes, type: :array, default: [], banner: "attribute attribute"

  def add_route
    invoke "resource_route"
  end

  def add_navigation
    append_to_file File.join("app/views", namespaced_path, "shared/_navigation.html.erb") do
      <<-END.strip_heredoc
        <%= navbar_item #{class_name} %>
      END
    end
  end

  def create_model
    if namespaced?
      template "resource_model.rb", File.join("app/models", class_path, "#{file_name}.rb")
    end
  end

  def create_controller
    template "resource_controller.rb", File.join("app/controllers", class_path, "#{file_name.pluralize}_controller.rb")
  end

  def create_service
    template "resource_service.rb", File.join("app/services", class_path, "#{file_name}_service.rb")
  end
end
