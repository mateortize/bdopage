class AddPostFieldToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :post_id, :integer
  end
end
