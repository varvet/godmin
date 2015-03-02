module Godmin
  module Model
    module BatchActions
      extend ActiveSupport::Concern

      delegate :batch_action_map, to: "self.class"

      def batch_action(action, item_ids)
        if batch_action?(action)
          send("batch_action_#{action}", resource_class.find(item_ids))
          true
        else
          false
        end
      end

      def batch_action?(action)
        batch_action_map.key?(action.to_sym)
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
