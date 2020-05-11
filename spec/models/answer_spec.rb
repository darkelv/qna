require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "votable"
  it_behaves_like 'commentable'

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#notify_user' do
    let(:answer) { build(:answer) }

    it 'calls NotificationJob' do
      expect(NotificationJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end

  context "best answer" do
    let!(:question) { create(:question) }

    it "sets best answer" do
      answer = create(:answer)
      expect(answer).to_not be_best

      answer.make_best
      expect(answer).to be_best
    end

    it "sets only one best answer" do
      answer1, answer2, answer3 = create_list(:answer, 3, question: question)

      answer1.make_best
      answer2.make_best

      [answer1, answer2, answer3].each { |a| a.reload }

      expect(answer1).to_not be_best
      expect(answer2).to be_best
      expect(answer3).to_not be_best
    end
  end

  context 'Author can pick one answer to his question as the best' do
    let(:user1) { create(:user_with_questions, questions_count: 2) }
    let(:user2) { create(:user) }
    let(:question_without_award) { user1.questions.last }
    let!(:answer_with_award) { create(:answer, question: question, user: user2) }
    let!(:answer_without_award) { create(:answer, question: question_without_award, user: user2) }
    let!(:award) { create(:award, :with_image, question: question) }
    let(:question) { user1.questions.first }

    it "Best answer's author get award, attached to question" do
      expect(user2.awards).to be_empty

      answer_with_award.make_best
      expect(user2.awards.first).to eq award
    end

    it "Best answer's author don't get award, because question hasn't got it" do
      answer_without_award.make_best
      expect(user2.awards).to be_empty
    end
  end
end
