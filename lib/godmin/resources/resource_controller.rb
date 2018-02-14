require "godmin/helpers/batch_actions"
require "godmin/helpers/filters"
require "godmin/helpers/tables"
require "godmin/resources/resource_controller/batch_actions"

# problem: we are modifying the resource service during the request cycle, which means
# we need to memoize all calls to service, resource etc. not good...
# we should build up things in the controller, not from the view layer?
# https://github.com/thoughtbot/guides/pull/398

module Godmin
  module Resources
    module ResourceController
      extend ActiveSupport::Concern

      include BatchActions

      included do
        helper Godmin::Helpers::BatchActions
        helper Godmin::Helpers::Filters
        helper Godmin::Helpers::Tables

        # TODO: helper methods are available everywhere to all partials, try using
        # locals instead so we only pass the stuff we need...
        # helper_method :resource_class
        # helper_method :resource_service
        # helper_method :resource_parents
        # helper_method :resources
        # helper_method :resource
      end

      def index
        # TODO: needed because things need to happen in a certain order, not good
        resource_service
        resources

        locals = {
          resource_class: resource_class,
          resource_service: resource_service,
          resource_parents: resource_parents,
          resources: resources
        }

        respond_to do |format|
          format.html { render :index, locals: locals }
          format.json
          format.csv
        end
      end

      def show
        respond_to do |format|
          format.html
          format.json
        end
      end

      def new; end

      def edit; end

      def create
        # TODO: needed because things need to happen in a certain order, not good
        resource_service
        resource

        respond_to do |format|
          if resource_service.create_resource(resource)
            format.html { redirect_to redirect_after_create, notice: redirect_flash_message }
            format.json { render :show, status: :created, location: resource }
          else
            format.html { render :edit }
            format.json { render json: resource.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        respond_to do |format|
          if resource_service.update_resource(resource, resource_params)
            format.html { redirect_to redirect_after_update, notice: redirect_flash_message }
            format.json { render :show, status: :ok, location: resource }
          else
            format.html { render :edit }
            format.json { render json: resource.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        resource_service.destroy_resource(resource)

        respond_to do |format|
          format.html { redirect_to redirect_after_destroy, notice: redirect_flash_message }
          format.json { head :no_content }
        end
      end

      protected

      def resource_service_class
        @_resource_service_class ||= "#{controller_path.singularize}_service".classify.constantize
      end

      def resource_service
        @_resource_service ||= begin
          resource_service = resource_service_class.new

          if authentication_enabled?
            resource_service.options[:admin_user] = admin_user
          end

          if resource_parents.present?
            resource_service.options[:resource_parent] = resource_parents.last
          end

          resource_service
        end
      end

      def resource_class
        @_resource_class ||= resource_service.resource_class
      end

      def resource_parents
        @_resource_parents ||= begin
          params.to_unsafe_h.each_with_object([]) do |(name, value), parents|
            if name =~ /(.+)_id$/
              parents << $1.classify.constantize.find(value)
            end
          end
        end
      end

      def resources
        @_resources ||= begin
          resources = resource_service.resources(params)
          authorize(resources) if authorization_enabled?
          resources
        end
      end

      def resource
        @_resource ||= begin
          resource =
            if params[:id]
              resource_service.find_resource(params[:id])
            else
              case action_name
              when "create"
                resource_service.build_resource(resource_params)
              when "new"
                resource_service.build_resource(nil)
              end
            end
          authorize(resource) if authorization_enabled?
          resource
        end
      end

      def resource_params
        params.require(resource_class.model_name.param_key.to_sym).permit(resource_params_defaults)
      end

      def resource_params_defaults
        resource_service.attrs_for_form.map do |attribute|
          association = resource_class.reflect_on_association(attribute)

          if association && association.macro == :belongs_to
            association.foreign_key.to_sym
          else
            attribute
          end
        end
      end

      def redirect_after_create
        redirect_after_save
      end

      def redirect_after_update
        redirect_after_save
      end

      def redirect_after_save
        [*resource_parents, resource]
      end

      def redirect_after_destroy
        [*resource_parents, resource_class.model_name.route_key.to_sym]
      end

      def redirect_flash_message
        translate_scoped("flash.#{action_name}", resource: resource.class.model_name.human)
      end
    end
  end
end
