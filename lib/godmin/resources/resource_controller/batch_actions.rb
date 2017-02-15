module Godmin
  module Resources
    module ResourceController
      module BatchActions
        extend ActiveSupport::Concern

        included do
          prepend_before_action :perform_batch_action, only: :update
        end

        protected

        def perform_batch_action
          return unless params[:batch_action].present?

          set_resource_service
          set_resource_class

          if authorization_enabled?
            authorize(batch_action_records, "batch_action_#{params[:batch_action]}?")
          end

          if @resource_service.batch_action(params[:batch_action], batch_action_records)
            flash[:notice] = translate_scoped(
              "flash.batch_action", number_of_records: batch_action_ids.length,
                                    resource: @resource_class.model_name.human(count: batch_action_ids.length)
            )
            flash[:updated_ids] = batch_action_ids

            if respond_to?("redirect_after_batch_action_#{params[:batch_action]}", true)
              redirect_to send("redirect_after_batch_action_#{params[:batch_action]}")
              return
            end
          end

          redirect_back
        end

        def batch_action_ids
          @_batch_action_ids ||= params[:id].split(",").map(&:to_i)
        end

        def batch_action_records
          @_batch_action_records ||= @resource_class.where(id: batch_action_ids)
        end
      end
    end
  end
end
