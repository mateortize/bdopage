class AddDescriptionFieldToProfile < ActiveRecord::Migration
  def change
    add_column :account_profiles, :description, :text
  end
end
