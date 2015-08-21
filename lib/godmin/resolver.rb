module Godmin
  class BaseResolver < ::ActionView::FileSystemResolver
    def initialize(controller_path, engine_wrapper)
      super ""
      @controller_path = controller_path
      @engine_wrapper = engine_wrapper
    end

    def find_templates(name, prefix, partial, details)
      templates = []

      template_paths(prefix).each do |path|
        if templates.present?
          break
        else
          templates = super(name, path, partial, details)
        end
      end

      templates
    end
  end

  # # Matches templates such as:
  # # { name: index } => [app/views/resource/index, godmin/app/views/godmin/resource/index]
  # # { name: form } => [app/views/resource/_form, godmin/app/views/godmin/resource/_form]
  # # { name: title } => [app/views/resource/columns/_title]
  # class ResourceResolver < BaseResolver
  #   def template_paths(prefix)
  #     [
  #       File.join(@engine_wrapper.root, "app/views", clean_prefix_1(prefix)),
  #       File.join(Godmin::Engine.root, "app/views", clean_prefix_2(prefix))
  #     ]
  #   end
  #
  #   private
  #
  #   def clean_prefix_1(prefix)
  #     prefix.sub(/\A#{@controller_path}/, File.join(@engine_wrapper.namespaced_path, "resource"))
  #   end
  #
  #   def clean_prefix_2(prefix)
  #     prefix.sub(/\A#{@controller_path}/, "godmin/resource")
  #   end
  # end

  # Matches templates such as:
  # { name: welcome, prefix: application } => [godmin/app/views/godmin/application/welcome]
  # { name: navigation, prefix: shared } => [godmin/app/views/godmin/shared/navigation]
  class GodminResolver < BaseResolver
    def template_paths(prefix)
      [
        File.join(@engine_wrapper.root, "app/views", resource_path_for_engine(prefix)),
        File.join(Godmin::Engine.root, "app/views/godmin", resource_path_for_godmin(prefix)),
        File.join(Godmin::Engine.root, "app/views/godmin", default_path_for_godmin(prefix))
      ]
    end

    private

    def resource_path_for_engine(prefix)
      prefix.sub(/\A#{@controller_path}/, File.join(@engine_wrapper.namespaced_path, "resource"))
    end

    def resource_path_for_godmin(prefix)
      prefix.sub(/\A#{@controller_path}/, "resource")
    end

    def default_path_for_godmin(prefix)
      prefix.sub(/\A#{File.join(@engine_wrapper.namespaced_path)}/, "")
    end
  end
end
