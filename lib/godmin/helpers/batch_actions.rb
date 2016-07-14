module Godmin
  module Helpers
    module BatchActions
      def batch_action_link(name, options)
        return unless @resource_service.include_batch_action?(name)

        link_to(
          translate_scoped("batch_actions.labels.#{name}", default: name.to_s.titleize),
          @resource_class,
          method: :patch,
          class: "btn btn-default hidden",
          data: {
            behavior: "batch-actions-action-link",
            confirm: options[:confirm] ? translate_scoped("batch_actions.confirm_message") : false,
            value: name
          }
        )
      end
    end
  end
end
