require 'rails_helper'

feature 'User can sign in via github' do
  describe 'Authorized user' do
    given!(:user) { create(:user_with_authorizations) }
    given!(:any_email) { Faker::Internet.email }

    background { visit new_question_path }
    after { clean_mock_auth }

    scenario 'signs in via GitHub' do
      mock_auth_hash('github', any_email)

      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account.'
        end
  end

  describe 'Registered unauthorized user' do
    given!(:user) { create(:user) }
    given!(:user_email) { user.email }

    background { visit new_user_session_path }
    after { clean_mock_auth }

    context 'when provider give email' do
      scenario 'signs in via GitHub' do
        mock_auth_hash('github', user_email)

        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end

    context 'when provider does not give email' do
      scenario 'signs in via facebook' do
        mock_auth_hash('facebook')

        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from Facebook account.'
      end
    end
  end

  describe 'Unregistered user' do
    given!(:any_email) { Faker::Internet.email }

    background { visit new_user_session_path }
    after { clean_mock_auth }

    context 'when provider give email' do
      scenario 'signs in via GitHub' do
        mock_auth_hash('github', any_email)

        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end
  end
end
