class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy, :delete_file]
  before_action :check_user, only: [:update, :destroy, :delete_file]

  def delete_file
    @question.files.find(params[:file_id]).purge
    redirect_to @question
  end

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
  end

  def show
    @answer = @question.answers.build(user: current_user) if current_user
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
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def check_user
    unless current_user.author_of?(@question)
      head(:forbidden)
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end


  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
