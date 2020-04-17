require 'rails_helper'

feature 'User can delete links in his question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user) }
  given(:user1_question) { user1.questions.first }

  let!(:link) { create(:link, linkable: user1_question) }

  describe "Question's author try to delete" do
    scenario 'Link in his question', js: true do
      sign_in(user1)
      visit question_path(user1_question)

      within '.question-links' do
        expect(page).to have_link link.name, href: link.url
      end

      within 'section.question-links' do

        click_on 'Remove link'
        expect(page).not_to have_link link.name, href: link.url
      end
    end

    scenario "Link in another's question", js: true do
      sign_in(user2)
      visit question_path(user1_question)

      within 'section.question-links' do
        expect(page).not_to have_link 'Remove link'
      end
    end
  end

  scenario 'Guest try to delete link in question', js: true do
    visit question_path(user1_question)

    within 'section.question-links' do
      expect(page).not_to have_link 'Remove link'
    end
  end
end
