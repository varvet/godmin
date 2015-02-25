module Godmin
  module Model
    module Filters
      extend ActiveSupport::Concern

      module ClassMethods
        def apply_filters(filter_params)
          scope = all
          if filter_params.present?
            filter_params.each do |name, value|
              if filter_map.key?(name.to_sym) && value.present?
                scope = scope.send("filter_#{name}", value)
              end
            end
          end
          scope
        end

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
