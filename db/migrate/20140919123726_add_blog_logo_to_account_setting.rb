class AddBlogLogoToAccountSetting < ActiveRecord::Migration
  def change
    add_column :account_settings, :blog_logo, :string
  end
end
