class AnotherAdminSessionsController < ApplicationController
  include Godmin::Authentication::SessionsController
  include Godmin::Authentication

  def admin_user_class
    AnotherAdminUser
  end
end
