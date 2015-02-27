module Godmin
  module Model
    module BatchActions
      extend ActiveSupport::Concern

      delegate :batch_action_map, to: "self.class"

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
