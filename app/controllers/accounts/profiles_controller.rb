class Accounts::ProfilesController < Accounts::BaseController
  
  def index
    @profile = current_account.account_profile
  end

  def show
    @profile = current_account.account_profile
  end

  def new
    @profile = AccountProfile.new
    @profile.account = current_account
  end

  def create
    @profile = AccountProfile.create(profile_params)
    @profile.account = current_account
    @profile.save

    redirect_to accounts_profile_path
  end

  def edit
    @profile = current_account.account_profile
  end

  def update
    @profile = current_account.account_profile
    @profile.update_attributes(profile_params)
    redirect_to accounts_profile_path
  end

  private

  def profile_params
      params.require(:account_profile).permit(:first_name,:last_name, :avatar)
  end

end
