module Godmin
  module Resources
    module ResourceController
      module Nesting
        extend ActiveSupport::Concern

        included do
          prepend_before_action :set_resource_parents
        end

        protected

        def set_resource_parents
          @resource_parents = resource_parents
        end

        def resource_parents
          params.each_with_object([]) do |(name, value), parents|
            if name =~ /(.+)_id$/
              parents << $1.classify.constantize.find(value)
            end
          end
        end

        def resource_service
          service = super
          service.options[:resource_parent] = @resource_parents.last
          service
        end

        def redirect_after_save
          [*@resource_parents, @resource]
        end

        def redirect_after_destroy
          [*@resource_parents, resource_class.model_name.route_key.to_sym]
        end
      end
    end
  end
end
