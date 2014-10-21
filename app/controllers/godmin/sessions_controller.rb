module Godmin
  class SessionsController < Admin::ApplicationController
    layout "godmin/login"

    def new
      @resource = ::AdminUser.new
    end

    def create

    end

    def destroy

    end
  end
end
