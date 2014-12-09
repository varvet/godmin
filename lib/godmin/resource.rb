require "godmin/helpers/batch_actions"
require "godmin/helpers/filters"
require "godmin/helpers/tables"
require "godmin/resource/batch_actions"
require "godmin/resource/filters"
require "godmin/resource/ordering"
require "godmin/resource/pagination"
require "godmin/resource/scopes"

module Godmin
  module Resource
    extend ActiveSupport::Concern

    included do
      helper Godmin::Helpers::BatchActions
      helper Godmin::Helpers::Filters
      helper Godmin::Helpers::Tables

      include Godmin::Resource::BatchActions
      include Godmin::Resource::Filters
      include Godmin::Resource::Scopes
      include Godmin::Resource::Ordering
      include Godmin::Resource::Pagination

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
      respond_to do |format|
        format.html
        format.json { render json: @resources.to_json }
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: @resource.to_json }
      end
    end

    def new
    end

    def edit
    end

    def create
      @resource = resource_class.new(resource_params)

      respond_to do |format|
        if @resource.save
          format.html { redirect_to redirect_after_create, notice: redirect_flash_message }
          format.json { render :show, status: :created, location: @resource }
        else
          format.html { render :edit }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @resource.update(resource_params)
          format.html { redirect_to redirect_after_update, notice: redirect_flash_message }
          format.json { render :show, status: :ok, location: @resource }
        else
          format.html { render :edit }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @resource.destroy

      respond_to do |format|
        format.html { redirect_to redirect_after_destroy, notice: redirect_flash_message }
        format.json { head :no_content }
      end
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

    def redirect_after_create
      redirect_after_save
    end

    def redirect_after_update
      redirect_after_save
    end

    def redirect_after_save
      @resource
    end

    def redirect_after_destroy
      resource_class.model_name.route_key.to_sym
    end

    def redirect_flash_message
      translate_scoped("flash.#{action_name}", resource: @resource.class.model_name.human)
    end

    def resource_params
      params.require(resource_class.name.underscore.to_sym).permit(attrs_for_form)
    end
  end
end
