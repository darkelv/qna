require 'rails_helper'

feature 'User can view question', %q{
  All user can view question
} do

  given(:user) { create (:user) }
  given!(:questions) { create_list(:question, 3) }

  background do
    visit questions_path
  end

  scenario 'Authenticated user can view question' do
    sign_in(user)

    expect(page).to have_content("MyString", count: 3)
  end

  scenario 'Unauthenticated user can view question' do
    expect(page).to have_content("MyString", count: 3)
  end
end
