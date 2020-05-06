require 'rails_helper'

describe Question, type: :model do
  it_behaves_like "votable"
  it_behaves_like 'commentable'

  describe 'Association' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should have_one(:award).dependent(:destroy) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }

    it { should accept_nested_attributes_for :award }
    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
