module Godmin
  class ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      raise Pundit::NotAuthorizedError, "must be logged in" unless user
      @user = user
      @record = record
    end

    def has_admin_access?
      true
    end

    alias_method :index?, :has_admin_access?
    alias_method :show?, :has_admin_access?
    alias_method :create?, :has_admin_access?
    alias_method :new?, :has_admin_access?
    alias_method :update?, :has_admin_access?
    alias_method :edit?, :has_admin_access?
    alias_method :destroy?, :has_admin_access?

    class Scope < Struct.new(:user, :scope)
      def resolve
        scope.all
      end
    end
  end
end
