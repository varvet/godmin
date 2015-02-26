module Godmin
  module Model
    module Ordering
      extend ActiveSupport::Concern

      def apply_order(order_param, resources)
        if order_param.present?
          resources.order("#{resource_class.table_name}.#{order_column(order_param)} #{order_direction(order_param)}")
        else
          resources
        end
      end

      protected

      def order_column(order_param)
        order_param.rpartition("_").first
      end

      def order_direction(order_param)
        order_param.rpartition("_").last
      end
    end
  end
end
