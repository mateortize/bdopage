class AddViewsCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :views_count, :integer, default: 0
    add_index :posts, :views_count
  end
end
