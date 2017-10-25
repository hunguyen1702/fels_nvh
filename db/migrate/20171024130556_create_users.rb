class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.integer :role
      t.string :avatar

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
