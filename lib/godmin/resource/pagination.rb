module Godmin
  module Resource
    module Pagination
      extend ActiveSupport::Concern

      included do
        helper_method :current_page
        helper_method :pages
      end

      def apply_pagination(resources)
        resources.limit(pagination_limit).offset(pagination_offset)
      end

      private

      def current_page
        params[:page].present? ? params[:page].to_i : 1
      end

      def pagination_limit
        self.class.per_page
      end

      def pagination_offset
        (params[:page].to_i * self.class.per_page) - self.class.per_page
      end

      # threshold: 5
      # 1,2,(3),4,5,6,7,8,9,10,11,12 => 1,2,(3),4,5...
      # 1,2,3,4,5,6,7,8,(9),10,11,12 => ...8,(9),10,11,12
      # 1,2,3,4,5,6,(7),8,9,10,11,12 => ...5,6,(7),8,9...

      def pages
        x = (1..(resource_class.count.to_f / self.class.per_page).ceil)

        if x.count > 5
          if current_page < 5
            x.to_a.slice(0, 5)
          elsif current_page > (x.count - 5)
            x.to_a.slice(-5, 5)
          end
        else
          x
        end
      end

      module ClassMethods
        def per_page
          10
        end
      end
    end
  end
end
