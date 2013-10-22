module Godmin
  module ResourceHelper

    def column_header(resource_class, attr)
      attr = attr.to_s

      if resource_class.column_names.include? attr
        if params[:order]
          direction = params[:order].split('_').last == 'desc' ? 'asc' : 'desc'
        else
          direction = 'desc'
        end
        header = link_to resource_class.human_attribute_name(attr), url_for(params.merge(order: "#{attr}_#{direction}"))
      else
        header = resource_class.human_attribute_name(attr)
      end

      header
    end

    def column(resource, attr)
      #template_name = "admin/#{resource_class.to_s.pluralize.underscore}/column_#{attr}"
      template_name = "columns/#{attr}"
      if lookup_context.exists?(template_name, nil, true)
        render partial: template_name, locals: { resource: resource }
      else
        value = resource.send(attr.to_s)
        value = localize(value, format: :long) if value.is_a?(Date) || value.is_a?(Time)

        if resource.class.primary_key == attr.to_s
          link_to "##{value}", [:admin, resource]
        else
          value
        end
      end
    end

    def batch_action_url_for(resource_class)
      begin # HACK: this is because we need the batch_action route on all resources
        url_for(
          controller: resource_class.to_s.pluralize.downcase,
          action: 'batch_action'
        )
      rescue
        ""
      end
    end

  end
end
