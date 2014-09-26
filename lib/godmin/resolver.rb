module Godmin
  class Resolver < ::ActionView::FileSystemResolver
    def find_templates(name, prefix, partial, details)

      # THIS IS HOW IT WORKS:
      #
      # 1. name: index; prefix: admin/articles OR articles
      #
      #    admin/articles/admin/articles | admin/articles/articles < controller name + prefix !PARTIAL
      #    admin/articles < controller name
      #    admin/admin/articles | admin/articles < prefix !PARTIAL
      #    admin/resource/admin/articles | admin/resource/articles < resource + prefix !PARTIAL
      #    admin/resource
      #    admin
      #
      # 2. name: navigation; prefix: shared
      #
      #    admin/articles/shared < controller name + prefix
      #    admin/articles < controller name
      #    admin/shared < prefix
      #    admin/resource/shared < resource + prefix
      #    admin/resource
      #    admin
      #
      # 3. name: title; prefix: columns
      #
      #    admin/articles/columns < controller name + prefix
      #    admin/articles < controller name
      #    admin/columns < prefix
      #    admin/resource/columns < resource + prefix
      #    admin/resource < resource
      #    admin

      template = []

      template_paths(prefix, partial).each do |path|
        template = super(name, path, partial, details)

        if template.present?
          break
        end
      end

      template
    end

    def template_paths(prefix)
      raise ::NotImplementedError
    end
  end

  class FooResolver < Resolver
    def initialize(controller_name)
      super File.join(Godmin.mounted_as, "app/views")
      @controller_name = controller_name
    end

    def template_paths(prefix, partial)
      [
        [Godmin.mounted_as, @controller_name, prefix],
        [Godmin.mounted_as, @controller_name],
        [Godmin.mounted_as, prefix],
        [Godmin.mounted_as, "resource", prefix],
        [Godmin.mounted_as, "resource"],
        [Godmin.mounted_as]
      ].map { |path|
        path.compact.join("/")
      }.compact
    end
  end

  class BarResolver < Resolver
    def initialize(controller_name)
      super File.join(Godmin::Engine.root, "app/views")
      @controller_name = controller_name
    end

    def template_paths(prefix, partial)
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
