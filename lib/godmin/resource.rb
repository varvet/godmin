module Godmin
  module Resource
    extend ActiveSupport::Concern

    included do
      include Godmin::Helpers::BatchActions
      include Godmin::Helpers::Filters
      include Godmin::Helpers::Tables

      include Godmin::Resource::BatchActions
      include Godmin::Resource::Filters
      include Godmin::Resource::Scopes
      include Godmin::Resource::Ordering
      include Godmin::Resource::Pagination

      respond_to :html, :json

      before_action :set_resource_class
      before_action :set_resources, only: :index
      before_action :set_resource, only: [:show, :new, :edit, :update, :destroy]

      helper_method :attrs_for_index
      helper_method :attrs_for_form
    end

    def resource_class
      controller_name.classify.constantize
    end

    def resources_relation
      resource_class.all
    end

    def resources
      apply_pagination(
        apply_order(
          apply_filters(
            apply_scope(
              resources_relation
            )
          )
        )
      )
    end

    def resource
      if params[:id]
        resources_relation.find(params[:id])
      else
        resources_relation.new
      end
    end

    def index
      respond_with(@resources)
    end

    def show
      respond_with(@resource)
    end

    def new
      respond_with(@resource)
    end

    def edit
      respond_with(@resource)
    end

    def create
      @resource = resource_class.create(resource_params)
      respond_with(@resource)
    end

    def update
      @resource.update(resource_params)
      respond_with(@resource)
    end

    def destroy
      @resource.destroy
      respond_with(@resource)
    end

    # Gives the view access to the list of column names
    # to be printed in the index view
    def attrs_for_index
      []
    end

    # Gives the view access to the list of attributes
    # to be included in the default form
    def attrs_for_form
      []
    end

    protected

    def set_resource_class
      @resource_class ||= resource_class
    end

    def set_resources
      @resources ||= resources
      authorize(@resources) if authorization_enabled?
    end

    def set_resource
      @resource ||= resource
      authorize(@resource) if authorization_enabled?
    end

    def resource_params
      params.require(resource_class.name.downcase.to_sym).permit(attrs_for_form)
    end
  end
end
