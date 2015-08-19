module Godmin
  class BaseResolver < ::ActionView::FileSystemResolver
    def initialize(controller_path, engine)
      super File.join(engine.root, "app/views")
      @engine = engine
      @controller_path = controller_path
    end

    def find_templates(name, prefix, partial, details)
      templates = []

      template_paths(name, prefix, partial).each do |path|
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
    def template_paths(_name, prefix, _partial)
      [
        File.join(@path, clean_prefix(prefix, @engine.name)),
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
    def template_paths(_name, prefix, _partial)
      [
        File.join(Godmin::Engine.root, "app/views/godmin", clean_prefix(prefix))
      ]
    end

    private

    def clean_prefix(prefix)
      prefix.sub(/\A#{@engine.name}/, "")
    end
  end
end
