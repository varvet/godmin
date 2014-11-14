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
        view_context.t(
          translation_path(translate, scope),
          default: view_context.t(translation_path(translate), default: default, **options),
          **options)
      end

      def translation_path(translate, scope = nil)
        ["godmin", scope, translate].compact.join(".")
      end
    end
  end
end
