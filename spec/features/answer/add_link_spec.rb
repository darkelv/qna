require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user_with_questions, questions_count: 1) }
  given(:question) { user.questions.first }
  given(:url) { Faker::Internet.url }
  given(:url_alt) { Faker::Internet.url }
  given(:gist_url) { 'https://gist.github.com/darkelv/6bd013e175248026492b1b68c4a86f48' }

  background do
    sign_in(user)
    visit question_path(question)

    fill_in 'Answer Body', with: 'answer text'
  end

  scenario 'User adds link while adding answer', js: true do

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: url

    click_on 'Answer the question'

    within '.answers' do
      expect(page).to have_link 'My gist', href: url
    end
  end

  scenario 'User adds many links while adding answer', js: true do
    within '.nested-fields' do
      fill_in 'Link name', with: 'My gist1'
      fill_in 'Url', with: url
    end

    click_on 'Add_link'

    within '.links>.nested-fields' do
      fill_in 'Link name', with: 'My gist2'
      fill_in 'Url', with: url_alt
    end

    click_on 'Answer the question'

    expect(page).to have_link 'My gist1', href: url
    expect(page).to have_link 'My gist2', href: url_alt
  end

  scenario 'User adds links while adding answer with errors', js: true do
    fill_in 'Link name', with: ''
    fill_in 'Url', with: url

    click_on 'Answer the question'

    expect(page).to have_content "name can't be blank"
  end

  scenario 'User adds git-links when add answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer the question'

    expect(page).to have_content 'MyText'
    expect(page).not_to have_link 'My gist', href: gist_url
  end
end
