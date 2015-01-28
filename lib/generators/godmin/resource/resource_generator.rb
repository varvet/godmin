require "active_support/all"

class Godmin::ResourceGenerator < Rails::Generators::NamedBase
  argument :attributes, type: :array, default: [], banner: "attribute attribute"
  source_root File.expand_path("../templates", __FILE__)

  # TODO: if we can get rid of the godmin block, we can do this which
  # is much nicer: route "resources :#{file_name}"
  def add_route
    inject_into_file "config/routes.rb", after: "godmin do\n" do
      <<-END.strip_heredoc.indent(4)
        resources :#{plural_name}
      END
    end
  end

  def create_controller
    template "resource_controller.rb", File.join("app/controllers", class_path, "#{plural_file_name}_controller.rb")
  end
end
