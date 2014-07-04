class PagesController < ApplicationController
  skip_before_action :authenticate_account!
  skip_before_filter :restrict_access

  def impress
  end

  def terms_and_conditions
  end

end
