require "godmin/resources/resource_service/associations"
require "godmin/resources/resource_service/batch_actions"
require "godmin/resources/resource_service/filters"
require "godmin/resources/resource_service/ordering"
require "godmin/resources/resource_service/pagination"
require "godmin/resources/resource_service/scopes"

module Godmin
  module Resources
    module ResourceService
      extend ActiveSupport::Concern

      include Associations
      include BatchActions
      include Filters
      include Ordering
      include Pagination
      include Scopes

      attr_reader :options

      def initialize(options = {})
        @options = options
      end

      def resource_class
        @options[:resource_class] || resource_class_name.constantize
      end

      def resource_class_name
        self.class.name.demodulize.chomp("Service")
      end

      def resources_relation
        if options[:resource_parent].present?
          resource_class.where(options[:resource_parent].class.name.underscore => options[:resource_parent])
        else
          resource_class.all
        end
      end

      def resources(params)
        apply_pagination(
          params[:page], apply_order(
            params[:order], apply_filters(
              params[:filter], apply_scope(
                params[:scope], resources_relation
              )
            )
          )
        )
      end

      def find_resource(id)
        resources_relation.find(id)
      end

      def build_resource(params)
        resources_relation.new(params)
      end

      def create_resource(resource)
        resource.save
      end

      def update_resource(resource, params)
        resource.update(params)
      end

      def destroy_resource(resource)
        resource.destroy
      end

      def attrs_for_index
        self.class.attrs_for_index
      end

      def attrs_for_show
        self.class.attrs_for_show
      end

      def attrs_for_form
        self.class.attrs_for_form
      end

      def attrs_for_export
        self.class.attrs_for_export
      end

      module ClassMethods
        def attrs_for_index(*attrs)
          @attrs_for_index = attrs if attrs.present?
          @attrs_for_index || []
        end

        def attrs_for_show(*attrs)
          @attrs_for_show = attrs if attrs.present?
          @attrs_for_show || []
        end

        def attrs_for_form(*attrs)
          @attrs_for_form = attrs if attrs.present?
          @attrs_for_form || []
        end

        def attrs_for_export(*attrs)
          @attrs_for_export = attrs if attrs.present?
          @attrs_for_export || []
        end
      end
    end
  end
end
