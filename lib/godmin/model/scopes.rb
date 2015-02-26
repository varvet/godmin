module Godmin
  module Model
    module Scopes
      extend ActiveSupport::Concern

      delegate :scope_map, to: "self.class"

      def apply_scope(scope_param, resources)
        @scope = scope_param.blank? ? default_scope : scope_param

        if scope && scope_map.key?(scope.to_sym)
          send("scope_#{@scope}", resources)
        else
          fail NotImplementedError, "Scope #{@scope} not implemented"
        end
      end

      def scope
        @scope
      end

      # TODO: make setter for scope

      def scoped_by?(name)
        @scope == name.to_s
      end

      def scope_count(scope)
        send("scope_#{scope}", resources_relation).count
      end

      protected

      def default_scope
        scope = scope_map.find -> { scope_map.first } do |_key, value|
          value[:default] == true
        end

        scope ? scope[0].to_s : nil
      end

      module ClassMethods
        def scope_map
          @scope_map ||= {}
        end

        def scope(attr, options = {})
          scope_map[attr] = {
            default: false
          }.merge(options)
        end
      end
    end
  end
end
