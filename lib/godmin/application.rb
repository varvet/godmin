module Godmin
  module Application
    extend ActiveSupport::Concern

    included do
      include Godmin::Helpers::Translations

      before_action :append_view_paths
      before_action :authenticate_user

      layout "godmin/application"
    end

    def welcome; end

    private

    def append_view_paths
      append_view_path Godmin::EngineResolver.new(controller_name)
      append_view_path Godmin::GodminResolver.new(controller_name)
    end

    def authenticate_user; end
  end
end
