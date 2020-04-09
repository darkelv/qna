require 'rails_helper'

feature "Author can remove your question and can't remove other" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author)}

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    it 'remove question' do
      click_on 'Delete question'

      expect(page).to_not have_content question.title
    end
  end

  describe 'Random User' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    it 'remove question' do
      expect(page).to_not have_content 'Delete question'
    end
  end

  describe 'user not login' do
    background do
      visit question_path(question)
    end

    it 'remove answer' do
      expect(page).to_not have_content 'Delete question'
    end
  end

end
