module Godmin
  class Resolver < ::ActionView::FileSystemResolver
    def self.resolvers(controller_path, engine_wrapper)
      [
        EngineResolver.new(controller_path, engine_wrapper),
        GodminResolver.new(controller_path, engine_wrapper)
      ]
    end

    def initialize(path, controller_path, engine_wrapper)
      super(path)
      @controller_path = controller_path
      @engine_wrapper = engine_wrapper
    end

    def find_templates(name, prefix, *args)
      templates = []

      template_paths(prefix).each do |path|
        if templates.present?
          break
        else
          templates = super(name, path, *args)
        end
      end

      templates
    end
  end

  # Matches templates such as:
  #
  # { name: index, prefix: articles } => app/views/resource/index
  # { name: form, prefix: articles }  => app/views/resource/_form
  # { name: title, prefix: columns }  => app/views/resource/columns/_title
  class EngineResolver < Resolver
    def initialize(controller_path, engine_wrapper)
      super(File.join(engine_wrapper.root, "app/views"), controller_path, engine_wrapper)
    end

    def template_paths(prefix)
      [
        resource_path_for_engine(prefix)
      ]
    end

    def resource_path_for_engine(prefix)
      prefix.sub(/\A#{@controller_path}/, File.join(@engine_wrapper.namespaced_path, "resource")).sub(/\A\//, "")
    end
  end

  # Matches templates such as:
  #
  # { name: index, prefix: articles }      => godmin/app/views/godmin/resource/index
  # { name: form, prefix: articles }       => godmin/app/views/godmin/resource/_form
  # { name: welcome, prefix: application } => godmin/app/views/godmin/application/welcome
  # { name: navigation, prefix: shared }   => godmin/app/views/godmin/shared/navigation
  class GodminResolver < Resolver
    def initialize(controller_path, engine_wrapper)
      super(File.join(Godmin::Engine.root, "app/views/godmin"), controller_path, engine_wrapper)
    end

    def template_paths(prefix)
      [
        default_path_for_godmin(prefix),
        resource_path_for_godmin(prefix)
      ]
    end

    def default_path_for_godmin(prefix)
      prefix.sub(/\A#{File.join(@engine_wrapper.namespaced_path)}/, "").sub(/\A\//, "")
    end

    def resource_path_for_godmin(prefix)
      prefix.sub(/\A#{@controller_path}/, "resource").sub(/\A\//, "")
    end
  end
end
