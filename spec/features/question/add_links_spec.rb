require 'rails_helper'

feature 'Author can add links to his question' do
  given(:user) { create(:user) }
  given(:url) { Faker::Internet.url }
  given(:url_alt) { Faker::Internet.url }
  given(:gist_url) { 'https://gist.github.com/darkelv/6bd013e175248026492b1b68c4a86f48' }
  given(:gist_link_not_exist) { 'https://gist.github.com/darkelv/asdasdasd' }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body',  with: 'question text'
  end

  describe 'User successfully' do
    scenario 'adds link when asks question' do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: url

      click_on 'Ask'

      expect(page).to have_link 'My link', href: url
    end

    scenario 'adds many links when asks question', js: true do
      within('.nested-fields') do
        fill_in 'Link name', with: 'My gist1'
        fill_in 'Url', with: url
      end

      click_on 'Add_link'

      within('.links>.nested-fields') do
        fill_in 'Link name', with: 'My gist2'
        fill_in 'Url', with: url_alt
      end

      click_on 'Ask'

      expect(page).to have_link 'My gist1', href: url
      expect(page).to have_link 'My gist2', href: url_alt
    end

    scenario 'adds git-links when asks question' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_content '1'
      expect(page).not_to have_link 'My gist', href: gist_url
    end
  end

  describe 'User' do
    scenario 'adds links when asks question with errors' do
      fill_in 'Link name', with: ''
      fill_in 'Url', with: url

      click_on 'Ask'

      expect(page).to have_content "Links name can't be blank"
    end

    scenario 'adds git-link when asks question but they are no content' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_link_not_exist

      click_on 'Ask'

      expect(page).to have_content 'No such a gist'
      expect(page).not_to have_link 'My gist', href: gist_link_not_exist
    end
  end
end
