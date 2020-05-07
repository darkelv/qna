class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :set_subscription, only: [:show, :update]

  include Voted

  authorize_resource

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.with_attached_files.all
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_award
  end

  def show
    if current_user.present?
      @answer = @question.answers.new(user: current_user)
      @answer.links.new
    end
    gon.question_id = @question.id
    gon.question_author_id = @question.user_id
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

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def set_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
  end


  def question_params
    params.require(:question).permit(
      :title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy],
      award_attributes: %i[id title image _destroy]
    )
  end
end
