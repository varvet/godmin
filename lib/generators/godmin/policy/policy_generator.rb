class Godmin::PolicyGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def create_controller_files
    template "policy.rb", File.join("app/policies", class_path, "#{file_name}_policy.rb")
  end
end
