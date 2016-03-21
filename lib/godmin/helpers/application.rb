module Godmin
  module Helpers
    module Application
      # Renders the provided partial with locals if it exists, otherwise
      # yields the given block. The lookup context call is cached for
      # each partial.
      def partial_override(partial, locals = {})
        @_partial_override ||= {}

        if @_partial_override[partial].nil?
          @_partial_override[partial] = lookup_context.exists?(partial, nil, true)
        end

        if @_partial_override[partial]
          render partial: partial, locals: locals
        else
          yield
        end
      end

      # Wraps the policy helper so that it is always accessible, even when
      # authorization is not enabled. When that is the case, it returns a
      # policy that always returns true.
      def policy(resource)
        if authorization_enabled?
          super(resource)
        else
          Authorization::Policy.new(nil, nil, default: true)
        end
      end
    end
  end
end
