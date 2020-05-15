require 'sphinx_helper'

feature 'Guest can use search in the site' do
  given(:user1) { create(:user, email: 'test@email.com') }
  given(:user2) { create(:user) }

  describe 'Authorized user', sphinx: true do
    background do
      sign_in(user1)
      visit questions_path
    end

    scenario 'completes user search successfully' do
      ThinkingSphinx::Test.run do
        search_in('test@email.com', "user")

        expect(page).to have_content(user1.email)
        expect(page).not_to have_content(user2.email)
      end
    end

    scenario 'has found nothing' do
      ThinkingSphinx::Test.run do
        search_in('wrong_email', "user")

        expect(page).to have_content("Nothing has been found")
      end
    end

    scenario 'has empty query' do
      ThinkingSphinx::Test.run do
        search_in(' ', "user")

        expect(page).to have_content("Your request is empty")
      end
    end
  end

  describe 'Guest tries', sphinx: true do
    background { visit questions_path }

    scenario 'search user' do
      ['test@email.com', 'wrong_email'].each do |keywords|
        ThinkingSphinx::Test.run do
          search_in(keywords, "user")

          within '.col-12' do
            expect(page).not_to have_content(keywords)
          end
        end

        ThinkingSphinx::Test.run do
          search_in(keywords)

          within '.col-12' do
            expect(page).not_to have_content(keywords)
          end
        end
      end
    end
  end
end
