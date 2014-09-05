module Godmin
  module Devise
    class PasswordsController < ::Devise::SessionsController
      layout "godmin/devise"
    end
  end
end
