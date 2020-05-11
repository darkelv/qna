class NotificationMailer < ApplicationMailer
  def answer_notify(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email
  end
end
