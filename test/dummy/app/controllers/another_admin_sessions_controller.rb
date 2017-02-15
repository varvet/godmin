class AnotherAdminSessionsController < ApplicationController
  include Godmin::Authentication::SessionsController
  include Godmin::Authentication

  skip_before_action :authenticate_admin_user

  def admin_user_class
    AnotherAdminUser
  end
end
