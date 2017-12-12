require "godmin/authentication/sessions_controller"
require "godmin/authentication/user"

module Godmin
  module Authentication
    extend ActiveSupport::Concern

    included do
      before_action :authenticate

      helper_method :admin_user
      helper_method :admin_user_signed_in?
    end

    def authenticate
      return unless authentication_enabled?
      return if admin_user_signed_in?

      redirect_to new_session_path
    end

    def admin_user_class; end

    def admin_user
      return unless admin_user_class
      return unless session[:admin_user_id]

      @_admin_user ||= admin_user_class.find_by(id: session[:admin_user_id])
    end

    def admin_user_signed_in?
      admin_user.present?
    end
  end
end
