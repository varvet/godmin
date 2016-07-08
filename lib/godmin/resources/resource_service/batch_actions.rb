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

        def include_batch_action?(action)
          options = batch_action_map[action.to_sym]

          (options[:only].nil? && options[:except].nil?) ||
            (options[:only] && options[:only].include?(scope.to_sym)) ||
            (options[:except] && !options[:except].include?(scope.to_sym))
        end

        def include_batch_actions?
          batch_action_map.keys.any? do |action|
            include_batch_action?(action)
          end
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
