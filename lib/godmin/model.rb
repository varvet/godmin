require "godmin/model/batch_actions"
require "godmin/model/filters"
require "godmin/model/ordering"
require "godmin/model/pagination"
require "godmin/model/scopes"

module Godmin
  module Model
    extend ActiveSupport::Concern

    include Godmin::Model::BatchActions
    include Godmin::Model::Filters
    include Godmin::Model::Ordering
    include Godmin::Model::Pagination
    include Godmin::Model::Scopes

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
