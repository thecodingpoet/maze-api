class UpdateRequiredUserFields < ActiveRecord::Migration[5.1]
  def change
    change_column_null :users, :birth_year, true
  end
end
