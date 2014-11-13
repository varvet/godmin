module Godmin
  class Resolver < ::ActionView::FileSystemResolver
    attr_accessor :namespace, :controller_name

    def find_templates(name, prefix, partial, details)
      template = []

      template_paths(prefix, partial).each do |path|
        template = super(name, path, partial, details)

        if template.present?
          break
        end
      end

      template
    end

    def template_paths(prefix, _partial)
      [
        [namespace, controller_name, prefix],
        [namespace, controller_name],
        [namespace, prefix],
        [namespace, "resource", prefix],
        [namespace, "resource"],
        [namespace]
      ].map { |path| path.compact.join("/") }.compact
    end
  end

  class EngineResolver < Resolver
    def initialize(controller_name)
      super [Godmin.namespace, "app/views"].compact.join("/")
      self.namespace       = Godmin.namespace
      self.controller_name = controller_name
    end
  end

  class GodminResolver < Resolver
    def initialize(controller_name)
      super [Godmin::Engine.root, "app/views"].compact.join("/")
      self.namespace       = "godmin"
      self.controller_name = controller_name
    end
  end
end
