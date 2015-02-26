module Godmin
  module Model
    module Pagination
      extend ActiveSupport::Concern

      def apply_pagination(page_param, resources)
        @paginator = Paginator.new(per_page, page_param, resources)
        @paginator.paginate
      end

      def paginator
        @paginator
      end

      def per_page
        25
      end
    end
  end
end
