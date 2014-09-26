class AddBlogAliasChangedAtFieldToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :blog_alias_changed_at, :datetime
  end
end
