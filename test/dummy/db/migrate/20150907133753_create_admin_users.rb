class CreateAdminUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      t.string :email
      t.text :password_digest

      t.timestamps null: false
    end
  end
end
