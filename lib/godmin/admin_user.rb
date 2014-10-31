module Godmin
  module AdminUser
    extend ActiveSupport::Concern

    included do
      has_secure_password

      validates :password, length: { minimum: 8 }, allow_nil: true
    end

    def login
      send(self.class.login_column)
    end

    module ClassMethods
      def find_by_login(login)
        find_by(login_column => login)
      end

      def login_column
        :email
      end
    end
  end
end
