module Godmin
  module TranslateHelper
    def godmin_translate(translate, default: nil)
      if @resource_class
        t("godmin.#{@resource_class.to_s.underscore}.#{translate}", resource: @resource_class.model_name.human, default: default || t("godmin.#{translate}", resource: @resource_class.model_name.human))
      else
        t("godmin.#{translate}")
      end
    end
  end
end
