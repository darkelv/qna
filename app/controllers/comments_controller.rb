class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: :destroy

  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save
  end

  def destroy
    @comment.delete
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def commentable
    klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def question_id
    commentable.class == Question ? commentable.id : commentable.question_id
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "question_#{question_id}_comments",
      comment: @comment
    )
  end
end
