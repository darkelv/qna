class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, except: [:create]
  before_action :set_question
  before_action :check_answer_author, except: [:create, :set_best]
  before_action :check_question_author, only: :set_best

  def set_best
    @answer.make_best
    @answers = @question.answers
  end

  def check_question_author
    unless current_user.author_of?(@question)
      head(:forbidden)
    end
  end

  def check_answer_author
    unless current_user.author_of?(@answer)
      head(:forbidden)
    end
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    redirect_to @question
  end

  private

  def check_user
    unless current_user.author_of?(@answer)
      redirect_to @answer.question, alert: "Only author allowed to modify answer"
    end
  end

  def set_question
    if params[:question_id]
      @question = Question.find(params[:question_id])
    else
      @question = @answer.question
    end
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: [:name, :url])
  end
end
