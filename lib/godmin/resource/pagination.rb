module Godmin
  module Resource
    module Pagination
      extend ActiveSupport::Concern

      WINDOW_SIZE = 7

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
        (current_page * self.class.per_page) - self.class.per_page
      end

      def pages
        @pages ||= begin
          pages = (1..total_pages).to_a

          return pages unless total_pages > WINDOW_SIZE

          if current_page < WINDOW_SIZE
            pages.slice(0, WINDOW_SIZE)
          elsif current_page > (total_pages - WINDOW_SIZE)
            pages.slice(-WINDOW_SIZE, WINDOW_SIZE)
          else
            pages.slice(pages.index(current_page) - (WINDOW_SIZE / 2), WINDOW_SIZE)
          end
        end
      end

      def total_pages
        @total_pages ||= (total_resources.to_f / self.class.per_page).ceil
      end

      def total_resources
        @total_resource ||= resources.limit(nil).offset(nil).count
      end

      module ClassMethods
        def per_page
          25
        end
      end
    end
  end
end
