class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
  end

  def edit
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
    if @question.update(question_params)
      redirect_to @question, notice: 'Your Question was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def check_user
    unless current_user.author_of?(@question)
      redirect_to @question, alert: 'Only author allowed to edit this question'
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end


  def question_params
    params.require(:question).permit(:title, :body)
  end
end
