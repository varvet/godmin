module Godmin
  class ApplicationController < ActionController::Base
    before_action :authenticate_user

    def welcome
    end

    private

    def authenticate_user
      nil
    end
  end
end
