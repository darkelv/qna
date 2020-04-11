require 'rails_helper'

feature "Author can remove your answer and can't remove other" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author)}
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
    end
    it 'remove answer' do
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
    end
  end
  describe 'Random User' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    it 'remove answer' do
      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'user not login' do
    background do
      visit question_path(question)
    end

    it 'remove answer' do
      expect(page).to_not have_link 'Delete answer'
    end
  end
end
