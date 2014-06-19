module Godmin
  module ApplicationHelper

    def godmin_render_partial(partial, locals: {})
      render partial: (godmin_locate_partial(partial) || partial), locals: locals
    end

    def godmin_locate_partial(partial, strict: false)
      paths = [
        "#{Godmin.mounted_as}/#{@resource_class.to_s.underscore.pluralize}",
        "#{Godmin.mounted_as}/resource",
        "#{Godmin.mounted_as}",
        "godmin/resource",
        "godmin"
      ]

      located_partial = nil

      paths.each do |path|
        if lookup_context.exists?("#{path}/#{partial}", nil, true)
          located_partial = "#{path}/#{partial}"; break
        end
      end

      located_partial
    end

  end
end
