module Godmin
  module Helpers
    module Translations
      extend ActiveSupport::Concern

      included do
        helper_method :godmin_translate
      end

      def godmin_translate(translate, scope: nil, default: nil, **options)
        if @resource_class
          scope ||= @resource_class.to_s.underscore
          options[:resource] ||= @resource_class.model_name.human
        end
        defaults = []
        defaults << ["godmin", scope, translate].compact.join(".").to_sym
        defaults << ["godmin", translate].join(".").to_sym
        defaults << default

        view_context.t(defaults.shift, default: defaults, **options)
      end
    end
  end
end
