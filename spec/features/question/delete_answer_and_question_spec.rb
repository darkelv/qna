require 'rails_helper'

feature "Author can remove your question and answer and can't remove other question ore answer" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author)}
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
    end
    it 'remove question' do
      click_on 'Delete question'

      expect(page).to have_content "Your question with title #{question.title} successfully delete."
    end
    it 'remove answer' do
      click_on 'Delete answer'

      expect(page).to have_content "Your answer with title #{answer.title} successfully delete."
    end
  end
  describe 'Random User' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    it 'remove answer' do
      click_on 'Delete answer'

      expect(page).to have_content answer.title
    end
    it 'remove question' do
      click_on 'Delete question'

      expect(page).to have_content question.title
    end
  end

end
