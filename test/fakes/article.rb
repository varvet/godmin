module Fakes
  class Article
    def self.table_name
      "articles"
    end

    def self.column_names
      %w[id title]
    end
  end
end
