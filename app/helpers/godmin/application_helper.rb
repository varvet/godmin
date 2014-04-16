module Godmin
  module ApplicationHelper

    def current_page?(controller, action = action_name)
      controller == controller_name && action == action_name
    end

    def current_url_contains?(string)
      request.fullpath.include?(string.downcase)
    end

   #def render_partial(template, locals: {})
   #  template_name = "admin/#{template}"

   #  unless lookup_context.exists?(template_name, nil, true)
   #    template_name = "godmin/#{template}"
   #  end

   #  render partial: template_name, locals: locals
   #end

  end
end
