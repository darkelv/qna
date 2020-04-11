require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of?' do
    let(:question) { create(:question) }
    let(:author) { create(:user) }
    let(:author_question) { create(:question, user: author) }

    it 'returns true for an author of object' do
      expect(author).to be_author_of(author_question)
    end

    it 'returns false for non-author of object' do
      expect(author).to_not be_author_of(question)
    end
  end
end
