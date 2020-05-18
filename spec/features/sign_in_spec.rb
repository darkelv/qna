require 'rails_helper'

feature 'User can sign in', %q(
  In order to ask questions
  As an ubautheticated user
  I'd like to be able to sign in
) do

  background { visit new_user_session_path }

  describe 'Registered user' do
    given(:user) { create (:user) }

    scenario 'tries to sign in' do
      # visit login page
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'tries to signet out' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      click_on 'Log out'

      expect(page).to have_content 'Signed out successfully'
    end

    scenario 'tries to sign up' do
      within(".navbar") do
        click_on 'Sign up'
      end
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      within "#new_user" do
        click_on 'Sign up'
      end

      expect(page).to have_content "Email has already been taken"
    end
  end

  describe "Unregistered user" do
    scenario 'tries to sign in' do
      fill_in 'Email', with: 'wrong@user.ru'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end

    scenario 'tries to sign up' do
      within(".navbar") do
        click_on 'Sign up'
      end
      fill_in 'Email', with: 'wrong@user.ru'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      within("#new_user") do
        click_on 'Sign up'
      end
      expect(page).to have_content "Welcome! You have signed up successfully."
    end
  end
end
