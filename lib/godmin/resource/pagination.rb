module Godmin
  module Resource
    module Pagination
      extend ActiveSupport::Concern

      included do
        helper_method :current_page
        helper_method :pages
        helper_method :total_pages
        helper_method :total_resources
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

      def pages
        pages = (1..total_pages).to_a

        return pages unless total_pages > 7

        if current_page < 7
          pages.slice(0, 7)
        elsif current_page > (total_pages - 7)
          pages.slice(-7, 7)
        else
          pages.slice(pages.index(current_page) - (7 / 2), 7)
        end
      end

      def total_pages
        (total_resources.to_f / self.class.per_page).ceil
      end

      def total_resources
        resources.limit(nil).offset(nil).count
      end

      module ClassMethods
        def per_page
          10
        end
      end
    end
  end
end
