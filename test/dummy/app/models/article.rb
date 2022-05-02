class Article < ActiveRecord::Base
  belongs_to :admin_user, optional: true
  has_many :comments

  def non_orderable_column
    "Not orderable"
  end

  def to_s
    title
  end
end
