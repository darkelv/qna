require 'rails_helper'

describe NotificationJob, type: :job do
  let(:user) { create(:user_with_questions, questions_count: 1) }
  let(:answer) { create(:answer, question: user.questions.first) }

  it 'calls NotificationService#answer_notify' do
    expect(NotificationService).to receive(:answer_notify).with(answer)
    NotificationJob.perform_now(answer)
  end
end
