class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.references :category, foreign_key: true
      t.string :content

      t.timestamps
    end
    add_index :words, [:category_id, :content], unique: true
  end
end
