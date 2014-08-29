class Godmin::InstallGenerator < Rails::Generators::NamedBase

  def create_initializer
    create_file "#{@name}/config/initializers/godmin.rb" do
      <<-END.strip_heredoc
        Godmin.configure do |config|
          config.mounted_as = "#{@name}"
        end
      END
    end
  end

  def create_routes
    inject_into_file "#{@name}/config/routes.rb", before: /^end/ do
      <<-END.strip_heredoc.indent(2)
        godmin do
        end
      END
    end
  end

  def create_controller
    gsub_file "#{@name}/app/controllers/#{@name}/application_controller.rb", "ActionController::Base" do |match|
      "Godmin::ApplicationController"
    end
  end

end
