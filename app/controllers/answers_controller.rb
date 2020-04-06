class AnswersController < ApplicationController
  expose :question, shallow_child: :answer
  expose :answers, from: :question
  expose :answer, shallow_parent: :question

  def create
    answer = question.answers.new(answer_params)

    if answer.save
      redirect_to answer_path(answer)
    else
      render :new
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
    answer.destroy
    redirect_to question_path(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
