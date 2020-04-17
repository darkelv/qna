class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    resource = @link.linkable
    if current_user.author_of?(resource)
      @link.destroy
    else
      head(:forbidden)
    end
  end
end
