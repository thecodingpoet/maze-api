class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :avatar, null: false
      t.string :username, null: false
      t.string :gender, null: false
      t.string :email, null: false
      t.integer :birth_year, null: false

      t.timestamps
    end
  end
end
