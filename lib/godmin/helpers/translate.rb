module Godmin
  module Helpers
    module Translate
      extend ActiveSupport::Concern

      included do
        helper_method :godmin_translate
      end

      def godmin_translate(translate, default: nil)
        if @resource_class
          view_context.t("godmin.#{@resource_class.to_s.underscore}.#{translate}", resource: @resource_class.model_name.human, default: default || t("godmin.#{translate}", resource: @resource_class.model_name.human))
        else
          view_context.t("godmin.#{translate}")
        end
      end
    end
  end
end
