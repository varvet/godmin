module Godmin
  class Resolver < ::ActionView::FileSystemResolver
    def initialize(path, controller_name)
      super(path)
      @controller_name = controller_name
    end

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

    def template_paths(_prefix)
      raise ::NotImplementedError
    end
  end

  class FooResolver < Resolver
    def initialize(controller_name)
      super([Godmin.mounted_as, "app/views"].compact.join("/"), controller_name)
    end

    def template_paths(prefix, _partial)
      [
        [Godmin.mounted_as, @controller_name, prefix],
        [Godmin.mounted_as, @controller_name],
        [Godmin.mounted_as, prefix],
        [Godmin.mounted_as, "resource", prefix],
        [Godmin.mounted_as, "resource"],
        [Godmin.mounted_as]
      ].map { |path| path.compact.join("/") }.compact
    end
  end

  class BarResolver < Resolver
    def initialize(controller_name)
      super([Godmin::Engine.root, "app/views"].compact.join("/"), controller_name)
    end

    def template_paths(prefix, _partial)
      [
        "godmin/#{@controller_name}/#{prefix}",
        "godmin/#{@controller_name}",
        "godmin/#{prefix}",
        "godmin/resource/#{prefix}",
        "godmin/resource",
        "godmin"
      ]
    end
  end
end
