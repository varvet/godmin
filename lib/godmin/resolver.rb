# Strategy:
# - Let rails resolvers go first and use them wherever possible
# - Split resolvers into responsibility, resource, shared etc
# - Add tests for namespaced stuff
# - We really need tests for mounted stuff as well..

# Issues:
# - Adding template files during tests seem to lead to random test failures,
#   running single tests work fine though... It works better if cache_classes
#   is set to false in the environtment config... Using a different capybara
#   driver does nothing.
# - Will the admin prefix be present if app run in engine?

module Godmin
  class BaseResolver < ::ActionView::FileSystemResolver
    def initialize(controller_path)
      super File.join(
        [Rails.application.root, Godmin.namespace, "app/views"].compact
      )
      @controller_path = controller_path
    end

    def find_templates(name, prefix, partial, details)
      templates = []

      template_paths(prefix, partial).each do |path|
        if templates.present?
          break
        else
          templates = super(name, path, partial, details)
        end
      end

      templates
    end
  end

  class ResourceResolver < BaseResolver
    def template_paths(_prefix, _partial)
      [
        File.join(@path, "resource", "columns"), # could be prefix, if it can be cleaned?
        File.join(@path, "resource"),
        File.join(Godmin::Engine.root, "app/views/godmin/resource")
      ]
    end
  end

  class SharedResolver < BaseResolver
    def template_paths(_prefix, _partial)
      [
        File.join(Godmin::Engine.root, "app/views/godmin/shared")
      ]
    end
  end
end






















module Godmin
  class Resolver < ::ActionView::FileSystemResolver
    attr_accessor :namespace, :controller_name

    def find_templates(name, prefix, partial, details)
      template = []

      template_paths(prefix, partial).each do |path|
        template = super(name, path, partial, details)

        break if template.present?
      end

      template
    end

    def template_paths(prefix, _partial)
      prefix = clean_prefix(prefix)
      [
        [namespace, controller_name, prefix],
        [namespace, controller_name],
        [namespace, prefix],
        [namespace, "resource", prefix],
        [namespace, "resource"],
        [namespace]
      ].map { |path| path.compact.join("/") }.compact
    end

    private

    def clean_prefix(prefix)
      prefix.gsub(/^#{namespace}\//, "")
    end
  end

  class EngineResolver < Resolver
    def initialize(controller_name)
      # Godmin.namespace || Rails.application.root
      super [Rails.application.root, "app/views"].compact.join("/")
      self.namespace = Godmin.namespace
      self.controller_name = controller_name
    end

    def template_paths(prefix, _partial)
      return [] if prefix =~ /^godmin\//
      super
    end
  end

  class GodminResolver < Resolver
    def initialize(controller_name)
      super [Godmin::Engine.root, "app/views"].compact.join("/")
      self.namespace = "godmin"
      self.controller_name = controller_name
    end
  end
end
