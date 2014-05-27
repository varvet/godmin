module Godmin
  module ResourceHelper

    def godmin_attribute_name(attribute)
      resource_class.human_attribute_name(attribute.to_s)
    end

    def godmin_column_header(attribute)
      if resource_class.column_names.include?(attribute.to_s)
        direction =
          if params[:order]
            if params[:order].split("_").first == attribute.to_s
              params[:order].split("_").last == "desc" ? "asc" : "desc"
            else
              params[:order].split("_").last
            end
          else
            "desc"
          end
        link_to godmin_attribute_name(attribute), url_for(params.merge(order: "#{attribute}_#{direction}"))
      else
        godmin_attribute_name(attribute)
      end
    end

    def godmin_column_value(resource, attribute)
      if godmin_locate_partial("columns/#{attribute}")
        godmin_render_partial("columns/#{attribute}", locals: { resource: resource })
      else
        column_value = resource.send(attribute)

        if column_value.is_a?(Date) || column_value.is_a?(Time)
          column_value = localize(column_value, format: :long)
        end

        column_value
      end
    end

    # def batch_action_link(name, options)
    #   # TODO: This is kinda fucked, but scope can probably be removed if it always exists
    #   if ((options[:only].nil? && options[:except].nil?) ||
    #       (options[:only] && params[:scope] && options[:only].include?(params[:scope].to_sym)) ||
    #       (options[:except] && (params[:scope].nil? || !options[:except].include?(params[:scope].to_sym))))

    #     confirm = options[:confirm] ? { confirm: 'Är du säker?' } : {}

    #     link_to '#', class: 'btn btn-default batch-process-action-link hidden', data: { value: name }.merge(confirm) do
    #       options[:label]
    #     end
    #   end
    # end

  end
end
