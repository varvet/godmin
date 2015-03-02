module Godmin
  module Resources
    module ResourceService
      module Pagination
        extend ActiveSupport::Concern

        def apply_pagination(page_param, resources)
          @paginator = Paginator.new(resources, per_page: per_page, current_page: page_param)
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
end
