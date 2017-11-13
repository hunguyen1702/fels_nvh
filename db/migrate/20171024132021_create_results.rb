class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.references :lesson, foreign_key: true
      t.references :word, foreign_key: true
      t.references :answer, foreign_key: true

      t.timestamps
    end
    add_index :results, [:id, :lesson_id, :word_id], unique: true
  end
end
