class AddVideoFieldToPost < ActiveRecord::Migration
  def change
    add_column :posts, :video_id, :integer
  end
end
