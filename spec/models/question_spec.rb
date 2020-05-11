require 'rails_helper'

describe Question, type: :model do
  it_behaves_like "votable"
  it_behaves_like 'commentable'

  describe 'Association' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should have_one(:award).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribed_users).through(:subscriptions).source(:user) }
  end

  describe 'Scopes' do
    let!(:question) { create(:question) }
    let!(:questions) { create_list(:question, 2, created_at: Date.yesterday) }

    it '.created_the_day_before' do
      expect(Question.created_prev_day).to eq questions
    end
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
