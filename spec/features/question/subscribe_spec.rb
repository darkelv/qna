require 'rails_helper'

feature 'User can subscribe and unsubscribe to the question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:question) { user1.questions.first }
  given(:user2) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'unsubscribes to his question' do
      sign_in(user1)
      visit question_path(question)

      within '.question-subscription' do
        expect(page).not_to have_content 'Subscribed'
        click_on 'Unsubscribed'
        expect(page).not_to have_content 'Unsubscribed'
      end
    end

    scenario 'subscribes and unsubscribe to any question' do
      sign_in(user2)
      visit question_path(question)

      within '.question-subscription' do
        expect(page).not_to have_content 'Unsubscribed'
        click_on 'Subscribed'
        expect(page).not_to have_content 'Subscribed'
        click_on 'Unsubscribed'
        expect(page).not_to have_content 'Unsubscribed'
      end
    end
  end

  describe 'As a Guest' do
    scenario 'tries to subscribes or unsubscribe' do
      visit question_path(question)

      expect(page).not_to have_content 'Unsubscribed'
      expect(page).not_to have_content 'Subscribed'
    end
  end
end
