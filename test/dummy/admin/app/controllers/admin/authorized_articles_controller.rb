require_dependency "admin/articles_controller"

module Admin
  class AuthorizedArticlesController < ArticlesController
    include Godmin::Authorization

    def admin_user
      "admin"
    end

    def resource_service_class
      Admin::ArticleService
    end
  end
end
