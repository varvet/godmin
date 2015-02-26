require "godmin/model/filters"
require "godmin/model/scopes"
require "godmin/model/ordering"
require "godmin/model/pagination"

module Godmin
  module Model
    extend ActiveSupport::Concern

    include Godmin::Model::Filters
    include Godmin::Model::Scopes
    include Godmin::Model::Ordering
    include Godmin::Model::Pagination

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
  end
end
