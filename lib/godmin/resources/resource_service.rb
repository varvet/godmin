require "godmin/resources/resource_service/batch_actions"
require "godmin/resources/resource_service/filters"
require "godmin/resources/resource_service/ordering"
require "godmin/resources/resource_service/pagination"
require "godmin/resources/resource_service/scopes"

module Godmin
  module Resources
    module ResourceService
      extend ActiveSupport::Concern

      include BatchActions
      include Filters
      include Ordering
      include Pagination
      include Scopes

      def initialize(resource_class = nil)
        @resource_class = resource_class
      end

      def resource_class
        @resource_class
      end

      def resources_relation
        resource_class.all
      end

      def resources(params)
        apply_pagination(params[:page],
          apply_order(params[:order],
            apply_filters(params[:filter],
              apply_scope(params[:scope],
                resources_relation
              )
            )
          )
        )
      end

      def build_resource(params)
        resources_relation.new(params)
      end

      def find_resource(id)
        resources_relation.find(id)
      end

      def attrs_for_index
        self.class.attrs_for_index
      end

      def attrs_for_form
        self.class.attrs_for_form
      end

      module ClassMethods
        def attrs_for_index(*attrs)
          @attrs_for_index = attrs if attrs.present?
          @attrs_for_index || []
        end

        def attrs_for_form(*attrs)
          @attrs_for_form = attrs if attrs.present?
          @attrs_for_form || []
        end
      end
    end
  end
end
