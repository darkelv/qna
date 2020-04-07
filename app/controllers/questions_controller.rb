class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  expose :questions, -> { Question.all }
  expose :question

  def create
    question.user = current_user
    if question.save
      redirect_to question_path(question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question_path(question)
    else
      render :edit
    end
  end

  def destroy
    return redirect_to question_path(question) unless current_user.questions.include?(question)
    question.destroy
    redirect_to questions_path, notice: "Your question with title #{question.title} successfully delete."
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
