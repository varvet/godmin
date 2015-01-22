module Godmin
  module Authorization
    class Policy
      attr_reader :user, :record

      def initialize(user, record, default: false)
        @user = user
        @record = record
        @default = default
      end

      def index?
        @default
      end

      def show?
        @default
      end

      def new?
        create?
      end

      def edit?
        update?
      end

      def create?
        @default
      end

      def update?
        @default
      end

      def destroy?
        @default
      end
    end
  end
end
