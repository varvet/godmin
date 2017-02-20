module Godmin
  class Paginator
    WINDOW_SIZE = 7

    attr_reader :per_page, :current_page

    def initialize(resources, per_page: 25, current_page: nil)
      @resources = resources
      @per_page = per_page
      @current_page = current_page ? current_page.to_i : 1
    end

    def paginate
      @resources.limit(per_page).offset(offset)
    end

    def pages
      @pages ||= begin
        pages = (1..total_pages).to_a

        return pages unless total_pages > WINDOW_SIZE

        if current_page < WINDOW_SIZE
          pages.slice(0, WINDOW_SIZE)
        elsif current_page > (total_pages - WINDOW_SIZE)
          pages.slice(-WINDOW_SIZE, WINDOW_SIZE)
        else
          pages.slice(pages.index(current_page) - (WINDOW_SIZE / 2), WINDOW_SIZE)
        end
      end
    end

    def total_pages
      @total_pages ||= (total_resources.to_f / per_page).ceil
    end

    def total_resources
      @total_resources ||= begin
        count = @resources.count

        if count.respond_to?(:count)
          count.count
        else
          count
        end
      end
    end

    private

    def offset
      (current_page * per_page) - per_page
    end
  end
end
