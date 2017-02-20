class CreateComment < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :article, index: true, foreign_key: true
      t.string :title
      t.text :body
    end
  end
end
