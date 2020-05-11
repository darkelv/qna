class NotificationJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    NotificationService.answer_notify(answer)
  end
end
