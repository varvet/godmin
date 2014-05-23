module Godmin
  class ApplicationController < ActionController::Base
    # before_filter :authenticate_user
    # before_filter :prepend_view_paths

    # def current_ability
    #   @current_ability ||= Admin::Ability.new(current_user)
    # end

    # rescue_from CanCan::AccessDenied do |exception|
    #   render text: "Access Denied", status: :unauthorized
    # end

    # def current_user
    #   Godmin.current_user_method ? send(Godmin.current_user_method) : nil
    # end

    # private

    # def authenticate_user
    #   if Godmin.authentication_method.is_a? Proc
    #     instance_eval(&Godmin.authentication_method)
    #   elsif Godmin.authentication_method
    #     self.send(Godmin.authentication_method)
    #   end
    # end

    # def prepend_view_paths
    #   prepend_view_path "app/views/admin"
    # end




    # before_filter :prepend_view_paths

    # def prepend_view_paths
    #   prepend_view_path "app/views/admin"
    #   prepend_view_path "app/views/godmin"
    # end


  end
end
