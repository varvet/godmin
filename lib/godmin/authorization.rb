require "pundit"
require "godmin/authorization/policy"

module Godmin
  module Authorization
    extend ActiveSupport::Concern

    include Pundit

    included do
      rescue_from Pundit::NotAuthorizedError do
        render plain: "You are not authorized to do this", status: 403, layout: "godmin/login"
      end
    end

    def pundit_user
      admin_user
    end
  end
end
