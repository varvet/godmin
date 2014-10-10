module Godmin
  module Resource
    module Ordering
      extend ActiveSupport::Concern

      def apply_order(resources)
        if params[:order].present?
          resources.order("#{resource_class.table_name}.#{order_column} #{order_direction}")
        else
          resources
        end
      end

      protected

      def order_column
        params[:order].rpartition("_").first
      end

      def order_direction
        params[:order].rpartition("_").last
      end
    end
  end
end
