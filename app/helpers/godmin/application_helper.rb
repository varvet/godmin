module Godmin
  module ApplicationHelper

    # def current_page?(controller, action = action_name)
    #   controller == controller_name && action == action_name
    # end

    # def current_url_contains?(string)
    #   request.fullpath.include?(string)
    # end

    def render_partial(template, path: nil, locals: {})
      template_name =
        if path
          if lookup_context.exists?("admin/#{path}/#{template}", nil, true)
            "admin/#{path}/#{template}"
          else
            "godmin/#{path}/#{template}"
          end
        else
          template
        end

      render partial: template_name, locals: locals
    end

  end
end
