require 'rails_helper'

feature 'Question editing' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link '(edit)'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      expect(page).to have_link '(edit)'
    end

    scenario 'edit his question', js: true do
      click_on '(edit)'

      fill_in "question_title", with: 'edited title'
      fill_in "question_body", with: 'edited body'
      click_button 'Save'

      expect(page).to_not have_button 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end

    scenario 'try to edit other user question', js: true do
      new_question = create(:question)

      visit question_path(new_question)

      expect(page).to_not have_link '(edit)'
    end

    scenario 'add files in edit form', js: true do
      click_on '(edit)'

      attach_file '(files)', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_button 'Save'

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end

    scenario 'author delete his question files' do
      question_with_image = create(:question, :with_files, user: user)

      visit question_path(question_with_image)

      expect(page).to have_link "Delete #{question_with_image.files.first.filename.to_s}"
      expect(page).to have_link "Delete #{question_with_image.files.last.filename.to_s}"

      click_on "Delete #{question_with_image.files.first.filename.to_s}"

      expect(page).to_not have_link "Delete #{question_with_image.files.first.filename.to_s}"
      expect(page).to have_link "Delete #{question_with_image.files.last.filename.to_s}"

      click_on "Delete #{question_with_image.files.last.filename.to_s}"

      expect(page).to_not have_link "Delete #{question_with_image.files.last.filename.to_s}"
    end

    scenario 'try to delete files other user question' do
      question_with_image = create(:question, :with_files)

      visit question_path(question_with_image)

      expect(page).to_not have_link "Delete #{question_with_image.files.first.filename.to_s}"
      expect(page).to_not have_link "Delete #{question_with_image.files.last.filename.to_s}"
    end
  end
end
