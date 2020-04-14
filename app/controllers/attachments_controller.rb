class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_attachment_author?

  def destroy
    attachment.purge
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment

  def user_is_attachment_author?
    resource = attachment.record
    unless current_user.author_of?(resource)
      head(:forbidden)
    end
  end
end
