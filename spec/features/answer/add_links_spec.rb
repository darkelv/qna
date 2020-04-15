require 'rails_helper'

feature 'User can add links to answer' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/darkelv/6bd013e175248026492b1b68c4a86f48' }

  scenario 'User adds links when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in "Answer Body", with: "My body"
    click_on "Answer the question"

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on "Answer the question"

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
