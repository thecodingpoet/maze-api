class AddCounterCacheToWritings < ActiveRecord::Migration[5.1]
  def change
    add_column :writings, :comments_count, :integer, default: 0
    Writing.find_each { |writing| Writing.reset_counters(writing.id, :comments) }
  end
end
