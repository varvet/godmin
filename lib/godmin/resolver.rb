module Godmin
  class Resolver < ::ActionView::FileSystemResolver
    def find_templates(name, prefix, partial, details)
      template = []

      template_paths(prefix).each do |path|
        template = super(name, path, partial, details)

        if template.present?
          break
        end
      end

      template
    end

    protected

    def template_paths(prefix)
      raise ::NotImplementedError
    end
  end

  class FooResolver < Resolver
    def initialize
      super File.join(Godmin.mounted_as, "app/views")
    end

    protected

    def template_paths(prefix)
      [
        [Godmin.mounted_as, prefix.split("/").last],
        [Godmin.mounted_as, "resource"],
        [Godmin.mounted_as]
      ].map { |path|
        path.compact.join("/")
      }.compact
    end
  end

  class BarResolver < Resolver
    def initialize
      super File.join(Godmin::Engine.root, "app/views")
    end

    protected

    def template_paths(prefix)
      [
        "godmin/#{prefix.split("/").last}",
        "godmin/resource",
        "godmin"
      ]
    end
  end
end
