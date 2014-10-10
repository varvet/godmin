module Godmin
  module Helpers
    module BatchActions
      extend ActiveSupport::Concern

      included do
        helper_method :batch_action_link
      end

      def batch_action_link(name, options)
        if (options[:only].nil? && options[:except].nil?) ||
           (options[:only] && options[:only].include?(params[:scope].to_sym)) ||
           (options[:except] && !options[:except].include?(params[:scope].to_sym))

          view_context.link_to(view_context.godmin_translate("batch_actions.#{name}", default: name.to_s.titleize), "#", class: "btn btn-default batch-actions-action-link hidden", data: {
            value: name,
            confirm: options[:confirm] ? view_context.godmin_translate("batch_actions.confirm_message") : false
          })
        end
      end
    end
  end
end
