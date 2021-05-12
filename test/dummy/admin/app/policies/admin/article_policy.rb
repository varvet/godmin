module Admin
  class ArticlePolicy < Godmin::Authorization::Policy
    def index?
      false
    end

    def new?
      true
    end
  end
end
