require "godmin/authorization/policy"
require "godmin/authorization/policy_finder"

module Godmin
  module Authorization
    extend ActiveSupport::Concern

    included do
      helper_method :policy

      rescue_from NotAuthorizedError do
        render text: "You are not authorized to do this", status: 403, layout: "godmin/login"
      end
    end

    def authorize(record)
      policy = policy(record)

      unless policy.public_send(action_name + "?")
        raise NotAuthorizedError
      end
    end

    def policy(record)
      policies[record] ||= PolicyFinder.find(record).new(admin_user, record)
    end

    def policies
      @_policies ||= {}
    end

    class NotAuthorizedError < StandardError; end
  end
end
