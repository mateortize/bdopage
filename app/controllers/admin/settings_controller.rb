class Admin::SettingsController < Admin::BaseController
  
  def index
    @setting = current_account.setting
  end

  def show
    @setting = current_account.setting
  end

  def new
    @setting = AccountSetting.new
    @setting.account = current_account
  end

  def edit
    @setting = current_account.setting
  end

  def update
    @setting = current_account.setting
    if @setting.update_attributes(setting_params)
      redirect_to account_path(current_account)
    else
      render :edit
    end 
    
  end

  private

  def setting_params
      params.require(:account_setting).permit(:blog_alias,:blog_enabled)
  end

end
