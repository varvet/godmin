module Godmin
  module Resources
    module ResourceController
      module Nesting
        extend ActiveSupport::Concern

        included do
          prepend_before_action :set_resource_parent_class
          prepend_before_action :set_resource_parent
        end

        protected

        def set_resource_parent_class
          @resource_parent_class = resource_parent.class
        end

        def set_resource_parent
          @resource_parent = resource_parent
        end

        # TODO: this one is a bit weird.. do we need all this?
        def resource_parent
          candidate = params.reduce([]) do |res, (name, value)|
            if name =~ /(.+)_id$/
              res = [$1, value]
            end
          end
          candidate[0].classify.constantize.find(candidate[1])
        end

        def resource_service
          service = super
          service.options[:resource_parent] = @resource_parent
          service
        end
      end
    end
  end
end
