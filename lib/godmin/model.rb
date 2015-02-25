require "godmin/model/filters"
require "godmin/model/scopes"

module Godmin
  module Model
    extend ActiveSupport::Concern

    include Godmin::Model::Filters
    include Godmin::Model::Scopes

    module ClassMethods
      def resources(params)
        apply_filters(params[:filter]).apply_scope(params[:scope])
      end
    end
  end
end
