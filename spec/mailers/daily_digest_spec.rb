require 'rails_helper'

describe DailyMailer, type: :mailer do
  let!(:user) { create(:user) }
  let!(:yesterday_questions) { create_list(:question, 2, created_at: Date.yesterday) }
  let!(:today_question) { create(:question) }

  describe 'digest' do
    let(:mail) { DailyMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body of the actual questions' do
      yesterday_questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end
  end
end
