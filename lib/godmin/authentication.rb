require "godmin/authentication/sessions_controller"
require "godmin/authentication/user"

module Godmin
  module Authentication
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_admin_user

      helper_method :admin_user
      helper_method :admin_user_signed_in?
    end

    def authenticate_admin_user
      unless admin_user_signed_in? || controller_name == "sessions"
        redirect_to new_session_path
      end
    end

    def admin_user_class
      raise NotImplementedError, "Must define the admin user class"
    end

    def admin_user
      if session[:admin_user_id]
        @admin_user ||= admin_user_class.find_by(id: session[:admin_user_id])
      end
    end

    def admin_user_signed_in?
      admin_user.present?
    end
  end
end
