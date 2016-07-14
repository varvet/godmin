class CommentService
  include Godmin::Resources::ResourceService

  attrs_for_index :id, :title
  attrs_for_show :id, :title, :body
  attrs_for_form :title, :body
end
