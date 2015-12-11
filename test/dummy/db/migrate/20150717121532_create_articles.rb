class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.boolean :published, default: false
      t.references :admin_user

      t.timestamps null: false
    end
  end
end
