module Godmin
  module Helpers
    module BatchActions
      def batch_action_link(name, options)
        return unless include_batch_action_link?(options)

        link_to(
          translate_scoped("batch_actions.labels.#{name}", default: name.to_s.titleize),
          @resource_class,
          method: :patch,
          class: "btn btn-secondary",
          data: {
            behavior: "batch-actions-action-link",
            confirm: options[:confirm] ? translate_scoped("batch_actions.confirm_message") : false,
            value: name
          }
        )
      end

      private

      def include_batch_action_link?(options)
        (options[:only].nil? && options[:except].nil?) ||
          (options[:only] && options[:only].include?(@resource_service.scope.to_sym)) ||
          (options[:except] && !options[:except].include?(@resource_service.scope.to_sym))
      end
    end
  end
end
