require 'rails_helper'

feature 'User can create comment' do
  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }
  given!(:answer1) { create(:answer, user: user, question: question) }
  given!(:answer2) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'makes comment to first answer' do
      within(".answer-#{answer1.id}") do
        fill_in 'Body', with: 'Test comment'
        click_on "Add comment"

        expect(page).to have_content 'Test comment'
        within '#new_comment' do
          expect(page).not_to have_content 'Test comment'
        end
      end
    end

    scenario 'makes comment to second answer' do
      within(".answer-#{answer2.id}") do
        fill_in 'Body', with: 'Test super'
        click_on "Add comment"

        expect(page).to have_content 'Test super'
        within '#new_comment' do
          expect(page).not_to have_content 'Test super'
        end
      end
    end

    scenario 'makes comment with errors' do
      within(".answer-#{answer2.id}") do
        click_on "Add comment"

        expect(page).to have_content "Bodycan't be blank"
        within '#new_comment' do
          expect(page).not_to have_content 'Test comment'
        end
      end
    end
  end

  describe 'As a Guest', js: true do
    scenario 'tries to make a comment' do
      visit question_path(question)

      within(".answer-#{answer1.id}") do
        expect(page).not_to have_content "Add comment"
      end
    end
  end

  describe 'Mulitple sessions', js: true do
    scenario "comment to answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within(".answer-#{answer1.id}") do
          fill_in 'Body', with: 'Test super'
          click_on "Add comment"

          expect(page).to have_content 'Test super'
        end
      end

      Capybara.using_session('guest') do
        within(".answer-#{answer1.id}") do
          expect(page).to have_content 'Test super'
        end
      end
    end
  end
end
