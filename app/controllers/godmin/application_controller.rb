module Godmin
  class ApplicationController < ActionController::Base
    before_filter :authenticate_user
    before_filter :prepend_view_paths

    def current_ability
      @current_ability ||= Admin::Ability.new(send(Godmin.current_user_method))
    end

    private

    def authenticate_user
      if Godmin.authentication_method
        self.send(Godmin.authentication_method)
      end
    end

    def prepend_view_paths
      prepend_view_path "app/views/admin"
    end

  end
end
