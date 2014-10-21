module Godmin
  module Application
    extend ActiveSupport::Concern

    included do
      include Godmin::Helpers::Translations

      before_action :append_view_paths
      before_action :authenticate_user

      layout "godmin/application"

      # TODO: where to put this one?
      helper_method :current_user
    end

    def welcome; end

    private

    def append_view_paths
      append_view_path Godmin::EngineResolver.new(controller_name)
      append_view_path Godmin::GodminResolver.new(controller_name)
    end

    def authenticate_user; end

    # TODO: do we also need user_signed_in? would it conflict with devise?
    def current_user
      if Godmin.admin_user_class && session[:admin_user_id]
        Godmin.admin_user_class.find(session[:admin_user_id])
      end
    end
  end
end
