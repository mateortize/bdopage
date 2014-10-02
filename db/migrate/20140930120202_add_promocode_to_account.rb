class AddPromocodeToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :promotion_code, :string
    add_index :accounts, :promotion_code

    add_column :accounts, :bonofa_partner_account_id, :integer
    add_index :accounts, :bonofa_partner_account_id
  end
end
