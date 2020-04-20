require 'rails_helper'

feature 'Author can update links in his question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions) }
  given(:question) { user1.questions.first }
  given!(:url) { Faker::Internet.url }

  given!(:link) { create(:link, linkable: question) }

  describe 'User' do
    background do
      sign_in(user1)
      visit question_path(question)
      click_on '(edit)'
    end

    scenario 'edits his question by adding link', js: true do
      within '.question-links' do
        expect(page).to have_link link.name, href: link.url
        expect(page).not_to have_link 'My ref1', href: url
      end

      within '.question-form-node' do
        click_on "Add_link"
      end

      within '.links>.nested-fields' do
        fill_in 'Link name', with: 'My ref1'
        fill_in 'Url', with: url
      end

      click_on 'Save'

      within '.question-links' do
        expect(page).to have_link link.name, href: link.url
        expect(page).to have_link 'My ref1', href: url
      end
    end

    scenario 'edits his question by deleting current link and adding new one', js: true do
      within '.question-links' do
        expect(page).to have_link link.name, href: link.url
      end

      within '.question-form-node' do
        click_on 'Remove link'
        click_on 'Add_link'
      end

      within '.links>.nested-fields' do
        fill_in 'Link name', with: 'My ref1'
        fill_in 'Url', with: url
      end

      click_on 'Save'

      within '.question-links' do
        expect(page).not_to have_link link.name, href: link.url
        expect(page).to have_link 'My ref1', href: url
      end
    end
  end
end
