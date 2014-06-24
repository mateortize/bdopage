class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :parent_id
      t.text :content
      t.timestamps
      
      t.references :post, index: true
      t.references :account, index: true
    end
  end
end
