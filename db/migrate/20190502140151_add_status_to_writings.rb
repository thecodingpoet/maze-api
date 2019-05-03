class AddStatusToWritings < ActiveRecord::Migration[5.1]
  def change
    add_column :writings, :status, :integer, default: 1
  end
end
