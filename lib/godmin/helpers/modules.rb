module Godmin
  module Helpers
    module Modules
      extend ActiveSupport::Concern

      included do
        helper_method :authentication_enabled?
        helper_method :authorization_enabled?
      end

      def authentication_enabled?
        singleton_class.include?(Godmin::Authentication)
      end

      def authorization_enabled?
        singleton_class.include?(Godmin::Authorization)
      end
    end
  end
end
