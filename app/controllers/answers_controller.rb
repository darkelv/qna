class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  expose :question, shallow_child: :answer
  expose :answers, from: :question
  expose :answer, shallow_parent: :question

  def create
    answer = question.answers.new(answer_params.merge(user: current_user))
    if answer.save
      redirect_to question_path(question)
    else
      flash[:alert] = "Answer can't be create"
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer_path(answer)
    else
      render :edit
    end
  end

  def destroy
    return redirect_to question_path(answer.question) unless current_user.answers.include?(answer)

    answer.destroy
    redirect_to question_path(answer.question), notice: "Your answer with title #{answer.title} successfully delete."
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
