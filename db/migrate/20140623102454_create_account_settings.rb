class CreateAccountSettings < ActiveRecord::Migration
  def change
    create_table :account_settings do |t|
      t.string :blog_alias
      t.boolean :blog_enabled
      t.timestamps

      t.references :account, index: true
    end
  end
end