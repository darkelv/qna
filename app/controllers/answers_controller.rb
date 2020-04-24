class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_answer_author, only: [:update, :destroy]
  before_action :check_question_author, only: :set_best

  include Voted

  after_action :publish_answer, only: :create

  def set_best
    answer.make_best
    @question = answer.question
  end

  def check_question_author
    unless current_user.author_of?(answer.question)
      head(:forbidden)
    end
  end

  def check_answer_author
    unless current_user.author_of?(answer)
      head(:forbidden)
    end
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question
    @answer.save
  end

  def edit
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    answer.destroy
    redirect_to question
  end

  private

  helper_method :answer, :question

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{question.id}_answers",
      answer: answer
    )
  end

  def check_user
    unless current_user.author_of?(answer)
      redirect_to answer.question, alert: "Only author allowed to modify answer"
    end
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.with_attached_files.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(
      :body, files: [], links_attributes: [:id, :name, :url, :_destroy]
    )
  end
end
