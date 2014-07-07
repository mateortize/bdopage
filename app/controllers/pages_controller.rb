class PagesController < ApplicationController
  skip_before_action :authenticate_account!
  skip_before_filter :restrict_access

  def impress
    if !@current_author.blank?
      @page = @current_author.pages.find_by(slug: 'imprint')
      render :accounts_impress if !@page.blank?
    end
  end

  def terms_and_conditions
  end

end
