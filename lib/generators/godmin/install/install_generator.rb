class Godmin::InstallGenerator < Rails::Generators::Base
  argument :path, type: :string

  def create_initializer
    create_file "#{@path}/config/initializers/godmin.rb" do
      <<-END.strip_heredoc
        Godmin.configure do |config|
          config.mounted_as = "#{@path}"
        end
      END
    end
  end

  def create_routes
    inject_into_file "#{@path}/config/routes.rb", before: /^end/ do
      <<-END.strip_heredoc.indent(2)
        godmin do
        end
      END
    end
  end

  def create_controller
    gsub_file "#{@path}/app/controllers/#{@path}/application_controller.rb", "ActionController::Base" do |match|
      "Godmin::ApplicationController"
    end
  end

end
