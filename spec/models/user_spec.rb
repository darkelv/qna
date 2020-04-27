require 'rails_helper'

describe User, type: :model do
  describe 'Association' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:awards) }
    it { should have_many(:authorizations).dependent(:destroy) }
  end

  describe 'Validation' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'Methods' do
    describe "Is user an resource's author" do
      let(:user1) { create(:user_with_questions, questions_count: 1) }
      let(:user2) { create(:user_with_questions, questions_count: 1) }

      it 'Is author of question' do
        expect(user1).to be_author_of(user1.questions.first)
      end

      it 'Is no author of question' do
        expect(user1).not_to be_author_of(user2.questions.first)
      end
    end

    describe "vote for" do
      let!(:question) { create(:question) }
      let!(:user) { create(:user) }

      describe "#voted_for?" do
        it "returns false" do
          expect(user.voted_for?(question)).to be false
        end

        it "returns true" do
          create(:vote, votable: question, user: user, voice: 1)
          expect(user.voted_for?(question)).to be true
        end
      end

      describe "#vote_for" do
        it "returns correct vote" do
          vote = create(:vote, votable: question, user: user, voice: 1)
          expect(user.vote_for(question)).to eq(vote)
        end

        it "false if no vote" do
          expect(user.vote_for(question)).to_not be true
        end
      end
    end

    describe '.find_for_oauth' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
      let(:service) { double('FindForOauthService') }

      it 'calls FindForOauthService' do
        expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
        expect(service).to receive(:call)
        User.find_for_oauth(auth)
      end
    end
  end
end
