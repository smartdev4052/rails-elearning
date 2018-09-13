class CreateChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :choices do |t|
      t.string :content
      t.boolean :judge
      t.references :word, foreign_key: true

      t.timestamps
    end
  end
end
