module Godmin
  module Devise
    class RegistrationsController < ::Devise::SessionsController
      layout "godmin/devise"
    end
  end
end
