module Godmin
  module Resources
    module ResourceService
      module Filters
        extend ActiveSupport::Concern

        delegate :filter_map, to: "self.class"

        def apply_filters(filter_params, resources)
          if filter_params.present?
            filter_params.each do |name, value|
              filter = filter_for(name)
              resources = filter.call(value, resources) if filter
            end
          end
          resources
        end

        def filters
          return {} unless defined? self.class::FILTERS
          @_filters ||= self.class::FILTERS.each_with_object({}) { |f, hash| hash[f.identifier.to_s] = f }
        end

        private

        def filter_for(field)
          filters[field]
        end

        # def filter(attr, options = {})
        #   filter_map[attr] = {
        #     as: :string,
        #     option_text: "to_s",
        #     option_value: "id",
        #     collection: nil
        #   }.merge(options)
        # end
      end
    end
  end
end
