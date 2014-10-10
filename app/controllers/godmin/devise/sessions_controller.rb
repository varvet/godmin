module Godmin
  module Devise
    class SessionsController < ::Devise::SessionsController
      layout "godmin/devise"
    end
  end
end
