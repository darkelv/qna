require 'rails_helper'

describe Link, type: :model do
  describe 'Association' do
    it { should belong_to :linkable }
  end

  describe 'Validation' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
    it { should allow_value(Faker::Internet.url).for(:url) }
    it { should_not allow_value('wrong_url').for(:url) }
  end

  describe 'Methods' do
    describe 'update_gits: add gist body after url validation' do
      let(:user) { create(:user_with_questions, questions_count: 1) }
      let!(:question) { user.questions.first }
      let!(:link) { create(:link, linkable: question) }

      context 'url is gist-url' do
        let!(:gist_link) { create(:link, :gist, linkable: question) }
        let!(:gist_link_not_exist) { create(:link, :gist_empty, linkable: question) }

        it 'gist url exist' do
          expect(gist_link.body).to match '1'
        end

        it 'gist url does not exist' do
          expect(gist_link_not_exist.body).to match 'No such a gist'
        end
      end

      context 'url is not gist-url' do
        it 'method does not work' do
          expect(link.body).not_to be_present
        end
      end
    end
  end
end
