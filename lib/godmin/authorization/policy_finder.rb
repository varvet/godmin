module Godmin
  module Authorization
    class PolicyFinder
      class << self
        def find(object, namespace = nil)
          return object.policy_class if object.respond_to?(:policy_class)
          return object.class.policy_class if object.class.respond_to?(:policy_class)

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

          if namespace
            "#{namespace}::#{klass}Policy"
          else
            "#{klass}Policy"
          end.constantize
        end
      end
    end
  end
end
