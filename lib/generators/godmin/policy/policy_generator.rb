require "godmin/generators/named_base"

class Godmin::PolicyGenerator < Godmin::Generators::NamedBase
  def create_policy
    template "policy.rb", File.join("app/policies", class_path, "#{file_name}_policy.rb")
  end
end
