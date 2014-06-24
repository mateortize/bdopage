class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :panda_video_id
      t.string :screenshot
      t.string :h264_url
      t.string :ogg_url
      t.string :height
      t.string :width
      t.string :file_size
      t.string :profile
      t.boolean :encoded, default: false
      t.timestamps

      t.references :account, index: true
    end
  end
end
