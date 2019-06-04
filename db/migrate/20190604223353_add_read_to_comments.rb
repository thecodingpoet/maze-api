class AddReadToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :read, :boolean, default: false
    Comment.update_all(read: true)
  end
end
