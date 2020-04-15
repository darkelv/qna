require 'rails_helper'

feature 'User can add links to question' do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/darkelv/6bd013e175248026492b1b68c4a86f48' }

  scenario 'User adds links when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'

    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
