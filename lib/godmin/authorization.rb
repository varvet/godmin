module Godmin
  module Authorization
    extend ActiveSupport::Concern

    included do
      helper_method :policy
    end

    def authorize(record)
      policy = policy(record)

      unless policy.public_send(action_name + "?")
        raise NotAuthorizedError
      end
    end

    def policy(record)
      self.class.policy_class(record).new(admin_user, record)
    end

    module ClassMethods
      def policy_class(object)
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
        [Godmin.mounted_as, "#{klass}_policy"].compact.join("/").classify.constantize
      end
    end

    class NotAuthorizedError < StandardError; end
  end
end
