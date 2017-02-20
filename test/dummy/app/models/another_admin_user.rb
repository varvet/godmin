class AnotherAdminUser < ActiveRecord::Base
  include Godmin::Authentication::User

  def self.login_column
    :email
  end
end
