class Godmin::ControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)
  argument :attributes, type: :array, default: [], banner: "attribute attribute"

  # TODO: if we can get rid of the godmin block, we can do this which
  # is much nicer: route "resources :#{file_name}"
  def add_route
    inject_into_file "config/routes.rb", after: "godmin do\n" do
      <<-END
    resources :#{file_name}
      END
    end
  end

  def create_controller
    template "controller.rb", File.join("app/controllers", class_path, "#{file_name}_controller.rb")
  end
end
