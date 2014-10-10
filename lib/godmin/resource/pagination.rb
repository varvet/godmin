module Godmin
  module Resource
    module Pagination
      extend ActiveSupport::Concern

      def apply_pagination(resources)
        resources.page(params[:page])
      end
    end
  end
end
