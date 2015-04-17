module Godmin
  module Resources
    module ResourceService
      module Filters
        extend ActiveSupport::Concern

        delegate :filter_map, to: "self.class"

        def apply_filters(filter_params, resources)
          if filter_params.present?
            filter_params.each do |name, value|
              if apply_filter?(name, value)
                resources = send("filter_#{name}", resources, value)
              end
            end
          end
          resources
        end

        private

        def apply_filter?(name, value)
          return false if value == [""]
          filter_map.key?(name.to_sym) && value.present?
        end

        module ClassMethods
          def filter_map
            @filter_map ||= {}
          end

          def filter(attr, options = {})
            filter_map[attr] = {
              as: :string,
              option_text: "to_s",
              option_value: "id",
              collection: nil
            }.merge(options)
          end
        end
      end
    end
  end
end
