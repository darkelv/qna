class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_user, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_award
  end

  def show
    if current_user.present?
      @answer = Answer.new(user: current_user)
      @answer.links.new
    end
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to question_path(@question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  def check_user
    unless current_user.author_of?(question)
      head(:forbidden)
    end
  end

  private

  helper_method :question

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end


  def question_params
    params.require(:question).permit(
      :title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy],
      award_attributes: %i[id title image _destroy]
    )
  end
end
