class SessionsController < ApplicationController
  include Godmin::Authentication::SessionsController
  include Godmin::Authentication

  def admin_user_class
    AdminUser
  end
end
