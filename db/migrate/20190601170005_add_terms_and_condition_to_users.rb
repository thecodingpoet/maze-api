class AddTermsAndConditionToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :terms_and_condition, :boolean, default: false
    User.update_all(terms_and_condition: true)
  end
end
