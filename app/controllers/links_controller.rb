class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link, only: :destroy

  authorize_resource

  def destroy
    @link.destroy
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end
end
