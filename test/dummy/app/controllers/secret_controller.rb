class SecretController < ApplicationController
  include Godmin::Authentication

  def admin_user_class
    AdminUser
  end
end
