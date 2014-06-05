module Godmin
  module TranslateHelper
    def godmin_translate_for_resource(translate, default: nil)
      I18n.t("godmin.#{resource_class.to_s.underscore}.#{translate}", resource: resource_class, default: default || I18n.t("godmin.#{translate}", resource: resource_class))
    end
  end
end
