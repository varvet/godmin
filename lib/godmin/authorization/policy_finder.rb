module Godmin
  module Authorization
    class PolicyFinder
      class << self
        def find(object)
          klass =
            if object.respond_to?(:model_name)
              object.model_name
            elsif object.class.respond_to?(:model_name)
              object.class.model_name
            elsif object.is_a?(Class)
              object
            elsif object.is_a?(Symbol)
              object.to_s.classify
            else
              object.class
            end

          if Godmin.namespace
            prefix = "#{Godmin.namespace.classify}::"
          end
          policy_class = "#{klass}Policy"
          add_prefix_once(prefix, policy_class)
        end

        private

        def add_prefix_once(prefix, s)
            if s.start_with?(prefix)
              s
            else
              "#{prefix}#{s}"
            end
        end
      end
    end
  end
end
