module Godmin
  module Resource
    module Scopes
      extend ActiveSupport::Concern

      included do
        helper_method :scope_map
      end

      def scope_map
        self.class.scope_map
      end

      def apply_scope(resources)
        if params[:scope].blank?
          params[:scope] = default_scope
        end

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
