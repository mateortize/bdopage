class AddVideoUrlFieldToPost < ActiveRecord::Migration
  def change
    add_column :posts, :video_url, :string
  end
end
