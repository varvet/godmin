module Godmin
  module Resources
    module ResourceService
      module Ordering
        extend ActiveSupport::Concern

        def apply_order(order_param, resources)
          if order_param.present? && order_column_method?(order_column(order_param))
            send("order_by_#{order_column(order_param)}", resources, order_direction(order_param))
          elsif order_param.present? && order_column_column?(order_column(order_param))
            resources.order("#{resource_class.table_name}.#{order_column(order_param)} #{order_direction(order_param)}")
          else
            resources
          end
        end

        def orderable_column?(column)
          order_column_method?(column) || order_column_column?(column)
        end

        protected

        def order_column_method?(column)
          respond_to?("order_by_#{column}")
        end

        def order_column_column?(column)
          resource_class.column_names.include?(column)
        end

        def order_column(order_param)
          order_param.rpartition("_").first
        end

        def order_direction(order_param)
          order_param.rpartition("_").last == "asc" ? "asc" : "desc"
        end
      end
    end
  end
end
