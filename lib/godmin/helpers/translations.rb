module Godmin
  module Helpers
    module Translations
      extend ActiveSupport::Concern

      included do
        helper_method :translate_scoped
      end

      def translate_scoped(translate, scope: nil, default: nil, **options)
        if @resource_class
          scope ||= @resource_class.to_s.underscore
        end

        defaults = []
        defaults << ["godmin", scope, translate].compact.join(".").to_sym
        defaults << ["godmin", translate].compact.join(".").to_sym
        defaults << default

        view_context.translate(defaults.shift, default: defaults, **options)
      end
    end
  end
end
