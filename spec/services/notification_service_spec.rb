require 'rails_helper'

describe NotificationService do
  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  context 'with subscribers' do
    let!(:subscriber) { create(:user) }
    let!(:unsubscriber) { create(:user) }

    let!(:answer) { create(:answer, question: question, user: unsubscriber) }

    before { create(:subscription, question: question, user: subscriber) }

    it 'sends notification about question update only to author and subscriber' do
      [author, subscriber].each do |user|
        expect(NotificationMailer).to receive(:answer_notify).with(user, answer).and_call_original
      end

      expect(NotificationMailer).not_to receive(:answer_notify).with(unsubscriber, answer).and_call_original

      NotificationService.answer_notify(answer)
    end
  end

  context 'without subscribers' do
    let!(:answer) { create(:answer, question: question, user: author) }

    before { Subscription.destroy_all }

    it 'does not send notifications about question' do
      expect(NotificationMailer).not_to receive(:answer_notify).with(author, answer).and_call_original

      NotificationService.answer_notify(answer)
    end
  end
end
