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
      policies[record] ||= PolicyFinder.find(record).constantize.new(admin_user, record)
    end

    def policies
      @_policies ||= {}
    end

    class NotAuthorizedError < StandardError; end
  end
end
