module Godmin
  module AdminUser
    extend ActiveSupport::Concern

    included do
      has_secure_password

      validates :password, length: { minimum: 8 }, allow_nil: true
    end
  end
end
