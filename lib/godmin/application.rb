module Godmin
  module Application
    extend ActiveSupport::Concern

    included do
      include Godmin::Helpers::Translate

      before_action :append_view_paths

      layout "godmin/application"
    end

    def welcome
    end

    private

    def append_view_paths
      append_view_path Godmin::FooResolver.new(controller_name)
      append_view_path Godmin::BarResolver.new(controller_name)
    end
  end
end
