module Godmin
  class ApplicationController < ActionController::Base
    before_action :authenticate_user

    def welcome
    end

    private

    def authenticate_user
      if Godmin.authentication_method
        self.send(Godmin.authentication_method)
      end
    end
  end
end
