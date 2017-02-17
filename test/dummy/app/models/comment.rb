class Comment < ActiveRecord::Base
  belongs_to :article

  def to_s
    title
  end
end
