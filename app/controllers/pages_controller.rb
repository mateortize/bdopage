class PagesController < ApplicationController
  skip_before_action :authenticate_account!
  skip_before_filter :restrict_access

  def imprint
  end

  def terms_and_conditions
  end

  def promotion
  end

  def show
  end
end
