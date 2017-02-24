class AnotherAdminSessionsController < ApplicationController
  include Godmin::Authentication::SessionsController
  include Godmin::Authentication

  skip_before_action :enable_authentication

  def admin_user_class
    AnotherAdminUser
  end
end
