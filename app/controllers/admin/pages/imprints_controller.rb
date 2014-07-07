class Admin::Pages::ImprintsController < Admin::BaseController
  
  set_tab :page

  def update
    @page = current_account.pages.find_or_create_by(slug: 'imprint')
    if @page.update_attributes(page_params)
      flash[:success] = "Updated successfully."
    end
    render :edit
  end

  def edit
    @page = current_account.pages.find_or_create_by(slug: 'imprint')
  end
  
  private

    def page_params
      params.require(:page).permit(:title,:content,:bootsy_image_gallery_id)
    end
end
