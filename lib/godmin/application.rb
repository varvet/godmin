module Godmin
  module Application
    extend ActiveSupport::Concern

    included do
      # include Godmin::Helpers::Render
      include Godmin::Helpers::Translate

      append_view_path Godmin::FooResolver.new
      append_view_path Godmin::BarResolver.new

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
