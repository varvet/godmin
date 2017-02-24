class AnotherAdminSessionsController < ApplicationController
  include Godmin::Authentication::SessionsController
  include Godmin::Authentication

  prepend_before_action :disable_authentication

  def admin_user_class
    AnotherAdminUser
  end
end
