class Comment < ActiveRecord::Base
  belongs_to :article, optional: true

  def to_s
    title
  end
end
