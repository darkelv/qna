require 'rails_helper'

describe NotificationMailer, type: :mailer do
  let!(:user) { create(:user_with_questions, questions_count: 1) }
  let!(:answer) { create(:answer, question: user.questions.first) }

  describe 'notify' do
    let(:mail) { NotificationMailer.answer_notify(user, answer) }

    it 'renders the headers' do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the question title' do
      expect(mail.body.encoded).to match(answer.question.title)
    end

    it 'renders the question body' do
      expect(mail.body.encoded).to match(answer.question.body.truncate(200))
    end

    it 'renders the answer body' do
      expect(mail.body.encoded).to match(answer.body.truncate(500))
    end
  end
end
