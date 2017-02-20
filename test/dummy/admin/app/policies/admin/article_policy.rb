module Admin
  class ArticlePolicy < Godmin::Authorization::Policy
    def index?
      false
    end
  end
end
