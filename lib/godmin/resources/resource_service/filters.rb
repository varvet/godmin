module Godmin
  module Resources
    module ResourceService
      module Filters
        extend ActiveSupport::Concern

        def apply_filters(filter_params, resources)
          if filter_params.present?
            filter_params.each do |name, value|
              filter = filters[name]
              resources = filter.call(resources, value) if filter
            end
          end
          resources
        end

        def filters
          return {} unless defined? self.class::FILTERS
          @_filters ||= self.class::FILTERS.each_with_object({}) { |f, hash| hash[f.identifier.to_s] = f }
        end
      end
    end
  end
end
