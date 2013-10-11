module Godmin
  class ApplicationController < ActionController::Base
    before_filter :prepend_view_paths

    private

    def prepend_view_paths
     prepend_view_path "app/views/admin"
    end

  end
end
