module Godmin
  class SessionsController < Admin::ApplicationController
    layout "godmin/login"

    def new
      @admin_user = admin_user_class.new
    end

    # TODO: implement correct routes
    def create
      @admin_user = admin_user_class.find_by(email: admin_user_params[admin_user_identifier])

      if @admin_user && @admin_user.authenticate(admin_user_params[:password])
        session[:admin_user_id] = @admin_user.id
        redirect_to "/admin", notice: "Successfully signed in"
      else
        redirect_to "/admin/sessions/new", alert: "Invalid email or password"
      end
    end

    def destroy
      session[:admin_user_id] = nil
      redirect_to "/admin/sessions/new", notice: "Signed out"
    end

    private

    def admin_user_class
      Godmin.admin_user_class
    end

    def admin_user_identifier
      Godmin.admin_user_identifier
    end

    def admin_user_params
      params.require(:admin_user).permit(
        admin_user_identifier,
        :password,
        :password_confirm
      )
    end
  end
end
