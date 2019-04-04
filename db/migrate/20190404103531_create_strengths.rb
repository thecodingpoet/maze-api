class CreateStrengths < ActiveRecord::Migration[5.1]
  def change
    create_table :strengths do |t|
      t.string :name
      t.boolean :selected, null: false
      t.references :user, foreign_key: true
      
      t.timestamps
    end
  end
end
