require "godmin/model/filters"
# require "godmin/model/scopes"

module Godmin
  module Model
    extend ActiveSupport::Concern

    include Godmin::Model::Filters
    # include Godmin::Model::Scopes

    def resource_class
      Article
    end

    def resources_relation
      resource_class.all
    end

    def resources(params)
      apply_filters(params[:filter], resources_relation) #.apply_scope(params[:scope])
    end
  end
end
