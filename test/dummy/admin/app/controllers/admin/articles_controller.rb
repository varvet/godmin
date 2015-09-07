require_dependency "admin/application_controller"

module Admin
  class ArticlesController < ApplicationController
    include Godmin::Resources::ResourceController
  end
end
