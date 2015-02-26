require "godmin/helpers/batch_actions"
require "godmin/helpers/filters"
require "godmin/helpers/tables"
require "godmin/resource/batch_actions"
require "godmin/resource/pagination"

module Godmin
  module Resource
    extend ActiveSupport::Concern

    included do
      helper Godmin::Helpers::BatchActions
      helper Godmin::Helpers::Filters
      helper Godmin::Helpers::Tables

      include Godmin::Resource::BatchActions
      include Godmin::Resource::Pagination

      before_action :set_thing
      before_action :set_resource_class
      before_action :set_resources, only: :index
      before_action :set_resource, only: [:show, :new, :edit, :create, :update, :destroy]

      helper_method :attrs_for_index
      helper_method :attrs_for_form
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

    def new; end

    def edit; end

    def create
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

    def set_thing
      @thing = thing_class.new(Article)
    end

    def set_resource_class
      @resource_class = resource_class
    end

    def set_resources
      @resources = resources
      authorize(@resources) if authorization_enabled?
    end

    def set_resource
      @resource = resource
      authorize(@resource) if authorization_enabled?
    end

    def thing_class
      Admin::ArticleThing
    end

    def resource_class
      @thing.resource_class
    end

    def resources
      @thing.resources(params)
    end

    def resource
      if params[:id]
        @thing.find_resource(params[:id])
      else
        case action_name
        when "create"
          @thing.build_resource(resource_params)
        when "new"
          @thing.build_resource(nil)
        end
      end
    end

    def resource_params
      params.require(resource_class.model_name.param_key.to_sym).permit(attrs_for_form)
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
  end
end
