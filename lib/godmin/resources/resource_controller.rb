require "godmin/helpers/batch_actions"
require "godmin/helpers/filters"
require "godmin/helpers/tables"

module Godmin
  module Resources
    module ResourceController
      extend ActiveSupport::Concern

      included do
        helper Godmin::Helpers::BatchActions
        helper Godmin::Helpers::Filters
        helper Godmin::Helpers::Tables

        before_action :set_resource_service
        before_action :set_resource_class
        before_action :set_resources, only: :index
        before_action :set_resource, only: [:show, :new, :edit, :create, :destroy]
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
        return if perform_batch_action

        set_resource

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

      protected

      def set_resource_service
        @resource_service = resource_service_class.new
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

      def resource_service_class
        "#{controller_path.singularize}_service".classify.constantize
      end

      # TODO: should we remove this?
      def resource_class
        @resource_service.resource_class
      end

      # TODO: should we remove this?
      def resources
        @resource_service.resources(params)
      end

      def resource
        if params[:id]
          @resource_service.find_resource(params[:id])
        else
          case action_name
          when "create"
            @resource_service.build_resource(resource_params)
          when "new"
            @resource_service.build_resource(nil)
          end
        end
      end

      def resource_params
        params.require(resource_class.model_name.param_key.to_sym).permit(@resource_service.attrs_for_form)
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

      def perform_batch_action
        return false unless params[:batch_action].present?

        item_ids = params[:id].split(",").map(&:to_i)

        if @resource_service.batch_action(params[:batch_action], item_ids)
          flash[:updated_ids] = item_ids

          if respond_to?("redirect_after_batch_action_#{params[:batch_action]}")
            redirect_to send("redirect_after_batch_action_#{params[:batch_action]}") and return true
          end
        end

        redirect_to :back and return true
      end
    end
  end
end
