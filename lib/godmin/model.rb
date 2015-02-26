require "godmin/model/filters"
require "godmin/model/scopes"

module Godmin
  module Model
    extend ActiveSupport::Concern

    include Godmin::Model::Filters
    include Godmin::Model::Scopes

    def resource_class
      Article
    end

    def resources_relation
      resource_class.all
    end

    # def resources
    #   apply_pagination(
    #     apply_order(
    #       apply_filters(
    #         apply_scope(
    #           resources_relation
    #         )
    #       )
    #     )
    #   )
    # end

    def resources(params)
      apply_filters(params[:filter], apply_scope(
        params[:scope], resources_relation
      ))
    end

    def build_resource(params)
      resources_relation.new(params)
    end

    def find_resource(id)
      resources_relation.find(id)
    end
  end
end
