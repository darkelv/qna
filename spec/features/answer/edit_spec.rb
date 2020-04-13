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

    scenario 'add files in edit form', js: true do
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Edit'

        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_button 'Save'
      end

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end

    scenario 'author delete his answer files' do
      answer_with_image = create(:answer, :with_files, user: user, question: question)

      visit question_path(answer_with_image.question)

      expect(page).to have_link "Delete #{answer_with_image.files.first.filename.to_s}"
      expect(page).to have_link "Delete #{answer_with_image.files.last.filename.to_s}"

      click_on "Delete #{answer_with_image.files.first.filename.to_s}"

      expect(page).to_not have_link "Delete #{answer_with_image.files.first.filename.to_s}"
      expect(page).to have_link "Delete #{answer_with_image.files.last.filename.to_s}"

      click_on "Delete #{answer_with_image.files.last.filename.to_s}"

      expect(page).to_not have_link "Delete #{answer_with_image.files.last.filename.to_s}"
    end

    scenario 'try to delete files other user answer' do
      answer_with_image = create(:answer, :with_files, question: question)

      visit question_path(answer_with_image.question)

      expect(page).to_not have_link "Delete #{answer_with_image.files.first.filename.to_s}"
      expect(page).to_not have_link "Delete #{answer_with_image.files.last.filename.to_s}"
    end
  end
end
