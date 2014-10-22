module Godmin
  module Application
    extend ActiveSupport::Concern

    included do
      include Godmin::Helpers::Translations

      before_action :append_view_paths

      layout "godmin/application"
    end

    def welcome; end

    private

    def append_view_paths
      append_view_path Godmin::EngineResolver.new(controller_name)
      append_view_path Godmin::GodminResolver.new(controller_name)
    end

    # TODO: think about how to extract this.. should there be an
    # Godmin::Helpers::Authentication module for the helpers and
    # a Godmin::Application::Authentication module for the
    # authenticate_user callback? when helper/not helper...
    concerning :Authentication do
      included do
        before_action :authenticate_user

        helper_method :admin_user
        helper_method :admin_user_signed_in?
      end

      # TODO: implement correct routes
      # TODO: think about moving conditionals somewhere else, signed in especially?
      def authenticate_user
        if Godmin.admin_user_class && !admin_user_signed_in? && controller_name != "sessions"
          redirect_to "/admin/sessions/new", alert: "Authentication needed"
        end
      end

      # TODO: memoize this value? what about when signing out?
      # TODO: if called current_admin_user or something, does it conflict with devise?
      def admin_user
        if Godmin.admin_user_class && session[:admin_user_id]
          Godmin.admin_user_class.find_by(id: session[:admin_user_id])
        end
      end

      def admin_user_signed_in?
        admin_user.present?
      end
    end
  end
end
