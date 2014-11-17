module Godmin
  module Resource
    module Pagination
      extend ActiveSupport::Concern

      included do
        helper_method :pages
      end

      def apply_pagination(resources)
        resources.limit(pagination_limit).offset(pagination_offset)
      end

      private

      def pagination_limit
        self.class.per_page
      end

      def pagination_offset
        self.class.per_page - (params[:page].to_i * self.class.per_page)
      end

      def pages
        1..(resources.count.to_f / self.class.per_page).ceil
      end

      module ClassMethods
        def per_page
          10
        end
      end
    end
  end
end
