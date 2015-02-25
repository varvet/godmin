module Godmin
  module Model
    module Scopes
      extend ActiveSupport::Concern

      module ClassMethods
        def scope_map
          @scope_map ||= {}
        end

        def scopifier(attr, options = {})
          scope_map[attr] = {
            default: false
          }.merge(options)
        end

        def default_scopify
          scopify = scope_map.find -> { scope_map.first } do |_key, value|
            value[:default] == true
          end

          scopify ? scopify[0].to_s : nil
        end

        def scope_count(scope)
          5
          # apply_filters(
          #   all.send("scope_#{scope}", resources_relation)
          # ).count
        end

        def apply_scope(scope_param)
          scope_param = default_scopify if scope_param.blank?
          all

          # if scope_param && scope_map.key?(scope_param.to_sym)
          #   send("scope_#{scope_param}", resources)
          # else
          #   all
          # end
        end
      end
    end
  end
end
