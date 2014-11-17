module Godmin
  module Authorization
    class Policy
      attr_reader :user, :record

      def initialize(user, record)
        @user = user
        @record = record
      end

      def index?
        false
      end

      def show?
        false
      end

      def new?
        create?
      end

      def edit?
        update?
      end

      def create?
        false
      end

      def update?
        false
      end

      def destroy?
        false
      end
    end
  end
end
