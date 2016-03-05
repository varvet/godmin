module Godmin
  module Resources
    module ResourceService
      module Nesting
        extend ActiveSupport::Concern

        def resources_relation
          super.where(options[:resource_parent].class.name.underscore => options[:resource_parent])
        end
      end
    end
  end
end
