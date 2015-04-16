module Godmin
  module Resources
    module ResourceService
      module BatchActions
        extend ActiveSupport::Concern

        delegate :batch_action_map, to: "self.class"

        def batch_action(action, records)
          if batch_action?(action)
            send("batch_action_#{action}", records)
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
end
