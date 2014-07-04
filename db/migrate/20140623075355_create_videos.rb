class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :panda_video_id
      t.boolean :encoded, default: false
      t.string :height
      t.string :width
      t.string :file_size
      t.string :screenshot

      t.references :account, index: true
      t.timestamps
    end
  end
end
