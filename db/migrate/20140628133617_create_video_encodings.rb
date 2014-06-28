class CreateVideoEncodings < ActiveRecord::Migration
  def change
    create_table :video_encodings do |t|

      t.string :profile_name
      t.string :panda_video_id
      t.string :status
      t.string :url
      t.integer :file_size
      t.integer :width
      t.integer :height
      t.references :video, index: true
      t.timestamps
    end
  end
end
