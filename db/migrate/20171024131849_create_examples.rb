class CreateExamples < ActiveRecord::Migration[5.1]
  def change
    create_table :examples do |t|
      t.references :word, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
