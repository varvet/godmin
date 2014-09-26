module Godmin
  module Helpers
    module Table
      extend ActiveSupport::Concern

      included do
        helper_method :column_header
        helper_method :column_value
      end

      def column_header(attribute)
        if @resource_class.column_names.include?(attribute.to_s)
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
          view_context.link_to @resource_class.human_attribute_name(attribute.to_s), url_for(params.merge(order: "#{attribute}_#{direction}"))
        else
          @resource_class.human_attribute_name(attribute.to_s)
        end
      end

      def column_value(resource, attribute)
        if view_context.lookup_context.exists?("columns/#{attribute}", nil, true)
          view_context.render partial: "columns/#{attribute}", locals: { resource: resource }
        else
          column_value = resource.send(attribute)

          if column_value.is_a?(Date) || column_value.is_a?(Time)
            column_value = view_context.l(column_value, format: :long)
          end

          if column_value.is_a?(TrueClass) || column_value.is_a?(FalseClass)
            column_value = view_context.t(column_value.to_s)
          end

          column_value
        end
      end
    end
  end
end
