require 'rails_helper'

feature 'Vote for question' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Non-author' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'Can voting up', js: true do
      click_on 'vote up'
      expect(page).to have_content 'rating: 1'
      expect(page).to_not have_link 'vote up'
    end

    scenario 'Can voting down', js: true do
      click_on 'vote down'
      expect(page).to have_content 'rating: -1'
      expect(page).to_not have_link 'vote down'
    end

    scenario 'Can cancel vote', js: true do
      click_on 'vote up'
      expect(page).to_not have_link 'vote up'
      click_on 'destroy vote'
      expect(page).to have_content 'rating: 0'
      expect(page).to have_link 'vote up'
    end
  end

  scenario 'Author can not vote' do
    sign_in question.user
    visit question_path(question)
    expect(page).to_not have_link 'vote up'
  end

  scenario 'Non-authenticated user can not vote' do
    visit question_path(question)
    expect(page).to_not have_link 'vote up'
  end
end
