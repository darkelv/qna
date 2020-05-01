class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy set_best]
  before_action :set_question, only: :create

  include Voted

  authorize_resource

  after_action :publish_answer, only: :create

  def set_best
    @answer.make_best
    @question = @answer.question
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@question.id}_answers",
      answer: @answer
    )
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(
      :body, files: [], links_attributes: [:id, :name, :url, :_destroy]
    )
  end
end
