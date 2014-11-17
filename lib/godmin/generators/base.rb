require "active_support/all"

module Godmin
  module Generators
    class Base < Rails::Generators::Base
      private

      def namespace
        Rails::Generators.namespace.to_s.underscore.presence
      end
    end
  end
end
