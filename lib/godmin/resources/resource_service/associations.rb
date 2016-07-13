module Godmin
  module Resources
    module ResourceService
      module Associations
        extend ActiveSupport::Concern

        delegate :has_many_map, to: "self.class"

        module ClassMethods
          def has_many_map
            @has_many_map ||= {}
          end

          def has_many(attr, options = {})
            has_many_map[attr] = {
              class_name: attr.to_s.singularize.classify
            }.merge(options)
          end
        end
      end
    end
  end
end
