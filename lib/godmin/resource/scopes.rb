module Godmin
  module Resource
    module Scopes
      extend ActiveSupport::Concern

      included do
        helper_method :scope_map
        helper_method :scope_count
      end

      def scope_map
        self.class.scope_map
      end

      def scope_count(scope)
        apply_filters(
          send("scope_#{scope}", resources_relation)
        ).count
      end

      def apply_scope(resources)
        params[:scope] = default_scope if params[:scope].blank?

        if params[:scope] && scope_map.key?(params[:scope].to_sym)
          send("scope_#{params[:scope]}", resources)
        else
          resources
        end
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
