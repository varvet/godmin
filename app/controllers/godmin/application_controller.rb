module Godmin
  class ApplicationController < ActionController::Base
    include Pundit
    before_action Godmin.authentication_method if Godmin.authentication_method
    before_action :authorize_admin

    def current_user
      Godmin.current_user_method
    end

    private
    
    def authorize_admin
      raise Pundit::NotAuthorizedError, "must be logged in" unless Godmin::ApplicationPolicy.new(current_user, nil).has_admin_access?
    end
  end
end
