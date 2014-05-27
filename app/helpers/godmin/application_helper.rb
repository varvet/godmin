module Godmin
  module ApplicationHelper

    # def current_page?(controller, action = action_name)
    #   controller == controller_name && action == action_name
    # end

    # def current_url_contains?(string)
    #   request.fullpath.include?(string)
    # end

    def godmin_render_partial(partial, locals: {})
      render partial: godmin_locate_partial(partial) || partial, locals: locals
    end

    # TODO: mounted as admin
    def godmin_locate_partial(partial, strict: false)
      paths = [
        "admin/#{resource_class.to_s.underscore.pluralize}",
        "admin/resource",
        "admin",
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
