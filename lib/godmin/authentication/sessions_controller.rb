module Godmin
  module Authentication
    module SessionsController
      extend ActiveSupport::Concern

      included do
        layout "godmin/login"
      end

      def new
        @admin_user = admin_user_class.new
      end

      def create
        @admin_user = admin_user_class.find_by_login(admin_user_login)

        if @admin_user && @admin_user.authenticate(admin_user_params[:password])
          session[:admin_user_id] = @admin_user.id
          redirect_to root_path, notice: t("godmin.sessions.signed_in")
        else
          redirect_to new_session_path, alert: t("godmin.sessions.failed_sign_in")
        end
      end

      def destroy
        session[:admin_user_id] = nil
        redirect_to new_session_path, notice: t("godmin.sessions.signed_out")
      end

      private

      def admin_user_login
        admin_user_params[admin_user_class.login_column]
      end

      def admin_user_params
        params.require(admin_user_class.model_name.param_key.to_sym).permit(
          admin_user_class.login_column,
          :password,
          :password_confirm
        )
      end
    end
  end
end
