module Godmin
  module Helpers
    module BatchActions
      def batch_action_link(name, options)
        if (options[:only].nil? && options[:except].nil?) ||
           (options[:only] && options[:only].include?(params[:scope].to_sym)) ||
           (options[:except] && !options[:except].include?(params[:scope].to_sym))

          link_to(translate_scoped("batch_actions.#{name}", default: name.to_s.titleize), "#", class: "btn btn-default hidden", data: {
            behavior: "batch-actions-action-link",
            confirm: options[:confirm] ? translate_scoped("batch_actions.confirm_message") : false,
            value: name
          })
        end
      end
    end
  end
end
