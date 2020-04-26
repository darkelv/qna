require 'rails_helper'

feature 'User can create comment' do
  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'makes comment' do
      within('.question-comments') do
        fill_in 'Body', with: 'Test comment'
        click_on 'Add comment'
      end

      expect(page).to have_content 'Test comment'
      within '#new_comment' do
        expect(page).not_to have_content 'Test comment'
      end
    end

    scenario 'makes comment with errors' do
      within('.question-comments') do
        click_on 'Add comment'
      end
      expect(page).to have_content "Bodycan't be blank"
      within '#new_comment' do
        expect(page).not_to have_content 'Test comment'
      end
    end
  end

  describe 'As a Guest', js: true do
    scenario 'tries to make a comment' do
      visit question_path(question)

      expect(page).not_to have_content 'Add comment'
    end
  end

  describe 'Mulitple sessions', js: true do
    scenario "comment to question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.question-comments') do
          fill_in 'Body', with: 'Test comment'
          click_on 'Add comment'
        end

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end
