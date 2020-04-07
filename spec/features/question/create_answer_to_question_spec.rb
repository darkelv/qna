require 'rails_helper'

feature 'User can write an answer to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can answer the question' do
      fill_in "Answer Title", with: "My answer"
      fill_in "Answer Body", with: "My body"
      click_on "Answer the question"

      expect(page).to have_content "My answer"
    end

    scenario 'answer a question with error' do
      click_on "Answer the question"

      expect(page).to have_content "Answer can't be create"
    end
  end

  scenario 'Unauthenticated user can answer the question' do
    visit question_path(question)

    click_on "Answer the question"

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'All user can view answer the question' do
    visit questions_path(answer.question)

    expect(page).to have_content answer.title
  end
end
