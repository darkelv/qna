require 'rails_helper'

feature 'User can delete links in his answer' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user) }
  given(:question) { user1.questions.first }
  given(:answer) { create(:answer, question: question, user: user2) }

  let!(:link) { create(:link, linkable: answer) }

  describe "Answer's author try to delete" do
    scenario 'Link in his answer', js: true do
      sign_in(user2)

      visit question_path(question)

      within '.answers' do
        expect(page).to have_link link.name, href: link.url
      end

      within 'section.answer-links' do
        click_on 'Remove link'
        expect(page).not_to have_link link.name, href: link.url
      end
    end

    scenario "Link in another's answer", js: true do
      sign_in(user1)

      visit question_path(question)

      within 'section.answer-links' do
        expect(page).not_to have_link 'Remove links'
      end
    end
  end

  scenario 'Guest try to delete link in answer', js: true do
    visit question_path(question)

    within 'section.answer-links' do
      expect(page).not_to have_link 'Remove link'
    end
  end
end
