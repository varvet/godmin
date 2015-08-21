module Godmin
  class BaseResolver < ::ActionView::FileSystemResolver
    def initialize(controller_path, engine_wrapper)
      super File.join(engine_wrapper.root, "app/views")
      @engine_namespace = engine_wrapper.namespace.to_s.underscore
      @controller_path = controller_path
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

  # Matches templates such as:
  # { name: index } => [app/views/resource/index, godmin/app/views/godmin/resource/index]
  # { name: form } => [app/views/resource/_form, godmin/app/views/godmin/resource/_form]
  # { name: title } => [app/views/resource/columns/_title]
  class ResourceResolver < BaseResolver
    def template_paths(prefix)
      [
        File.join(@path, clean_prefix(prefix, @engine_namespace)),
        File.join(Godmin::Engine.root, "app/views", clean_prefix(prefix, "godmin"))
      ]
    end

    private

    def clean_prefix(prefix, namespace)
      prefix.sub(/\A#{@controller_path}/, [namespace, "resource"].compact.join("/"))
    end
  end

  # Matches templates such as:
  # { name: welcome, prefix: application } => [godmin/app/views/godmin/application/welcome]
  # { name: navigation, prefix: shared } => [godmin/app/views/godmin/shared/navigation]
  class GodminResolver < BaseResolver
    def template_paths(prefix)
      [
        File.join(Godmin::Engine.root, "app/views/godmin", clean_prefix(prefix))
      ]
    end

    private

    def clean_prefix(prefix)
      prefix.sub(/\A#{@engine_namespace}/, "")
    end
  end
end
