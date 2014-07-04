class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :slug
      t.string :title
      t.text :content
      t.timestamps

      t.references :account, index: true
    end
  end
end
