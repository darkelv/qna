class NotificationService
  def self.answer_notify(answer)
    answer.question.subscribed_users.find_each do |user|
      NotificationMailer.answer_notify(user, answer).deliver_later
    end
  end
end
