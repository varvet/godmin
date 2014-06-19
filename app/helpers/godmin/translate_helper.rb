module Godmin
  module TranslateHelper
    def godmin_translate(translate, default: nil)
      I18n.t("godmin.#{@resource_class.to_s.underscore}.#{translate}", resource: @resource_class.model_name.human, default: default || I18n.t("godmin.#{translate}", resource: @resource_class.model_name.human))
    end
  end
end
