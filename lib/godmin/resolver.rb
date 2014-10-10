module Godmin
  class Resolver < ::ActionView::FileSystemResolver
    attr_accessor :namespace, :controller

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
        [namespace, controller, prefix],
        [namespace, controller],
        [namespace, prefix],
        [namespace, "resource", prefix],
        [namespace, "resource"],
        [namespace]
      ].map { |path| path.compact.join("/") }.compact
    end
  end

  class FooResolver < Resolver
    def initialize(controller)
      super [Godmin.mounted_as, "app/views"].compact.join("/")
      self.namespace  = Godmin.mounted_as
      self.controller = controller
    end
  end

  class BarResolver < Resolver
    def initialize(controller)
      super [Godmin::Engine.root, "app/views"].compact.join("/")
      self.namespace  = "godmin"
      self.controller = controller
    end
  end
end
