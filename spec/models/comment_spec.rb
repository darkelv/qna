require 'rails_helper'

describe Comment, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:body) }
  end

  describe '#to_s' do
    let(:comment) { build(:comment, :question, body: 'some text') }

    it { expect(comment.to_s).to eq 'some text' }
  end
end
