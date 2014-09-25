module Godmin
  class Resolver < ::ActionView::FileSystemResolver

    def initialize(type)
      case type
      when :app
        super File.join(Godmin.mounted_as, "app/views")
      when :godmin
        super File.join(Godmin::Engine.root, "app/views")
      end
      @type = type
    end

    def find_templates(name, prefix, partial, details)
      paths = []

      case @type
      when :app
        paths << [Godmin.mounted_as, prefix.split("/").last].compact.join("/")
        paths << [Godmin.mounted_as, "resource"].compact.join("/")
        paths << [Godmin.mounted_as].compact.join("/")
      when :godmin
        paths << "godmin/#{prefix.split("/").last}"
        paths << "godmin/resource"
        paths << "godmin"
      end

      template = []

      paths.each do |path|
        template = super(name, path, partial, details)
        break if template.present?
      end

      template
    end

  end
end
