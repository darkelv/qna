require 'rails_helper'

feature 'Author can add award to his question' do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body',  with: 'question text'
  end

  scenario 'User adds award while adding question' do
    fill_in 'Award name', with: 'My award1'
    attach_file 'Image',
                "#{Rails.root}/app/assets/images/all_in_level.jpg"

    click_on 'Ask'

    within('.question-image') do
      expect(page).to have_css("img[src*='all_in_level.jpg']")
    end
  end

  scenario 'User award while adding question without title' do
    fill_in 'Award name', with: ''
    attach_file 'Image',
                "#{Rails.root}/app/assets/images/all_in_level.jpg"

    click_on 'Ask'

    expect(page).to have_content "title can't be blank"
  end

  scenario 'User award while adding question without image' do
    fill_in 'Award name', with: 'My award1'

    click_on 'Ask'

    expect(page).to have_content I18n.t('activerecord.errors.messages.no_image')
  end
end
