class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.text :excerpt
      t.timestamps
      
      t.references :account, index: true
    end
  end
end
