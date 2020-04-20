require 'rails_helper'

feature 'User can write an answer to question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can answer the question' do
      fill_in "Answer Body", with: "My body"
      click_on "Answer the question"

      expect(page).to have_content "My body"
    end

    scenario 'answer a question with error' do
      click_on "Answer the question"

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in "Answer Body", with: "My body"

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on "Answer the question"

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  scenario 'Unauthenticated user can answer the question', js: true do
    visit question_path(question)

    expect(page).to_not have_link "Answer the question"
  end

  scenario 'All user can view answer the question' do
    visit question_path(question)

    expect(page).to have_content answer.body
  end
end
