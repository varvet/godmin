class Article < ActiveRecord::Base
  belongs_to :admin_user

  def non_orderable_column
    "Not orderable"
  end

  def to_s
    title
  end
end
