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

    def column_value(resource, attr)
      #template_name = "admin/#{resource_class.to_s.pluralize.underscore}/column_#{attr}"
      template_name = "columns/#{attr}"
      if lookup_context.exists?(template_name, nil, true)
        render partial: template_name, locals: { resource: resource }
      else
        value = resource.send(attr.to_s)
        value = localize(value, format: :long) if value.is_a?(Date) || value.is_a?(Time)

        if resource.class.primary_key == attr.to_s
          link_to "##{value}", [:admin, resource]
        elsif resource_class.reflect_on_association(attr.to_sym) && !value.nil?
          link_to value, [:admin, value]
        else
          value
        end
      end
    end

    def batch_action_link(name, options)
      # TODO: This is kinda fucked, but scope can probably be removed if it always exists
      if ((options[:only].nil? && options[:except].nil?) ||
          (options[:only] && params[:scope] && options[:only].include?(params[:scope].to_sym)) ||
          (options[:except] && (params[:scope].nil? || !options[:except].include?(params[:scope].to_sym))))

        confirm = options[:confirm] ? { confirm: 'Är du säker?' } : {}

        link_to class: 'btn btn-default batch-process-action-link hidden', data: { value: name }.merge(confirm) do
          options[:label]
        end
      end
    end

  end
end
