class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :remember_digest
      t.string :activation_digest
      t.boolean :is_activated, default: false
      t.datetime :activated_at
      t.integer :role, default: 0
      t.string :avatar

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
