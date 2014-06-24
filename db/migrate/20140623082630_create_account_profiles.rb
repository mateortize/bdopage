class CreateAccountProfiles < ActiveRecord::Migration
  def change
    create_table :account_profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :avatar

      t.timestamps
      
      t.references :account, index: true
    end
  end
end
