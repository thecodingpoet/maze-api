class AddApprovedToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :approved, :boolean
  end
end
