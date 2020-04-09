require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'test' do
    let(:question) { create(:question) }
    let(:author) { create(:user) }
    let(:author_question) { create(:question, user: author) }

    it 'author_of?' do
      expect(author.author_of?(question)).to eq false
      expect(author.author_of?(author_question)).to eq true
    end
  end
end
