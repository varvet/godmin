module Godmin
  module Helpers
    module Navigation
      def navbar_item(resource, url = resource, show: nil, icon: nil, **options)
        show ||= lambda do
          resource.is_a?(String) ? true : policy(resource).index?
        end

        return unless show.call

        link_text =
          if block_given?
            capture do
              yield
            end
          else
            resource.respond_to?(:model_name) ? resource.model_name.human(count: :many) : resource
          end

        content_tag :li do
          link_to url, options do
            if icon.present?
              concat content_tag :span, "", class: "glyphicon glyphicon-#{icon}"
              concat " "
            end
            concat link_text
          end
        end
      end

      def navbar_dropdown(title)
        dropdown_toggle = link_to "#", class: "dropdown-toggle", data: { toggle: "dropdown" } do
          concat "#{title} "
          concat content_tag :span, "", class: "caret"
        end

        dropdown_menu = content_tag :ul, class: "dropdown-menu" do
          yield
        end

        content_tag :li, class: "dropdown" do
          concat dropdown_toggle
          concat dropdown_menu
        end
      end

      def navbar_divider
        content_tag :li, "", class: "divider"
      end
    end
  end
end
