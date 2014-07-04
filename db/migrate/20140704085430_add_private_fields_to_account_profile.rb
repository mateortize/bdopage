class AddPrivateFieldsToAccountProfile < ActiveRecord::Migration
  def change
  	add_column :account_profiles, :private_fields, :string
  end
end
