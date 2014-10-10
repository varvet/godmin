module Godmin
  module Resource
    module BatchActions
      extend ActiveSupport::Concern

      included do
        helper_method :batch_action_map
      end

      def batch_action_map
        self.class.batch_action_map
      end

      def batch_action
        action   = params[:batch_action][:action]
        item_ids = params[:batch_action][:items].keys.map(&:to_i)

        if batch_action_map.key?(action.to_sym)
          # Store the batched item ids so they can be highlighted later
          flash[:batch_actioned_ids] = item_ids

          # If the batch action returns false, it is because it has implemented
          # its own redirect. Therefore we return wihout redirecting.
          return unless send("batch_action_#{action}", resource_class.find(item_ids))
        end

        redirect_to :back
      end

      module ClassMethods
        def batch_action_map
          @batch_action_map ||= {}
        end

        def batch_action(attr, options = {})
          batch_action_map[attr] = {
            only: nil,
            except: nil,
            confirm: false
          }.merge(options)
        end
      end
    end
  end
end
