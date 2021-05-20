require_dependency "admin/articles_controller"

module Admin
  class AuthorizedArticlesController < ArticlesController
    include Godmin::Authorization

    def admin_user
      "admin"
    end

    def new
      # The following calls to #policy are to check that the Authorization
      # module can handle various different scenarios:
      policy(Magazine).index?
      policy(::Magazine).index?
      policy(Magazine.new).index?
      policy(Magazine.all).index?
      policy(Admin::Magazine).index?
      policy(Admin::Magazine.new).index?
      policy(Admin::Magazine.where(name: "name")).index?

      super
    end

    def resource_service_class
      Admin::ArticleService
    end
  end
end
