module Godmin
  module Sessions
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
        redirect_to root_path, notice: "Successfully signed in"
      else
        redirect_to new_session_path, alert: "Invalid credentials"
      end
    end

    def destroy
      session[:admin_user_id] = nil
      redirect_to new_session_path, notice: "Signed out"
    end

    private

    def admin_user_login
      admin_user_params[admin_user_class.login_column]
    end

    def admin_user_params
      params.require(:admin_user).permit(
        admin_user_class.login_column,
        :password,
        :password_confirm
      )
    end
  end
end