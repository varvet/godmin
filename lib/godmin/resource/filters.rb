module Godmin
  module Resource
    module Filters
      extend ActiveSupport::Concern

      included do
        helper_method :filter_map
      end

      def filter_map
        self.class.filter_map
      end

      def apply_filters(resources)
        if params[:filter].present?
          params[:filter].each do |name, value|
            if filter_map.key?(name.to_sym) && value.present?
              resources = send("filter_#{name}", resources, value)
            end
          end
        end
        resources
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
