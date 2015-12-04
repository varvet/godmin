class AuthenticatedArticlesController < ArticlesController
  include Godmin::Authentication

  def admin_user_class
    AdminUser
  end

  def resource_service_class
    ArticleService
  end
end
