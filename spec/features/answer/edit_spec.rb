require 'rails_helper'

feature 'User can edit his answer' do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:user) { create(:user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in user
    end

    scenario 'edits his answer' do
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Edit'

        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      new_answer = create(:answer, question: question)

      visit question_path(question)

      within ".answer-#{new_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
