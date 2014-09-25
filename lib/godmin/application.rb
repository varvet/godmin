module Godmin
  module Application
    extend ActiveSupport::Concern

    included do
      # include Godmin::Helpers::Render
      include Godmin::Helpers::Translate

      append_view_path Godmin::Resolver.new(:app)
      append_view_path Godmin::Resolver.new(:godmin)

      layout "godmin/application"
    end

    def welcome
    end

    private

    # def _prefixes
    #   super + [
    #     [Godmin.mounted_as, "resource"].compact.join("/"),
    #     "godmin/#{controller_path.split("/").last}",
    #     "godmin/resource"
    #   ]
    # end
  end
end
