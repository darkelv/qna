require 'rails_helper'

feature 'Author can update links in his question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user) }
  given(:question) { user1.questions.first }
  given!(:answer) { create(:answer, question: question, user: user2) }

  given!(:url) { Faker::Internet.url }
  given!(:link) { create(:link, linkable: answer) }

  describe 'User' do
    background do
      sign_in(user2)
      visit question_path(question)

      click_on 'Edit'
      within ".answer-#{answer.id}" do
        fill_in 'Your answer', with: 'answer text'
      end
    end

    scenario 'edits his answers by adding link', js: true do
      within '.answer-links' do
        expect(page).to have_link link.name, href: link.url
        expect(page).not_to have_link 'My ref1', href: url
      end

      within ".answer-#{answer.id}" do
        click_on 'Add_link'
      end

      within '.links>.nested-fields' do
        fill_in 'Link name', with: 'My ref1'
        fill_in 'Url', with: url
      end

      within ".answer-#{answer.id}" do
        click_on 'Save'
      end

      within '.answer-links' do
        expect(page).to have_link link.name, href: link.url
        expect(page).to have_link 'My ref1', href: url
      end
    end
  end
end
