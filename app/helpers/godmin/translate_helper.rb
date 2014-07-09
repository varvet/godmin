module Godmin
  module TranslateHelper
    def godmin_translate(translate, default: nil)
      t("godmin.#{@resource_class.to_s.underscore}.#{translate}", resource: @resource_class.model_name.human, default: default || t("godmin.#{translate}", resource: @resource_class.model_name.human))
    end
  end
end
