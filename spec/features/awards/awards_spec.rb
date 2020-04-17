require 'rails_helper'

feature 'User can see his awarda' do
  given(:user1) { create(:user_with_questions, questions_count: 3) }
  given(:user2) { create(:user) }
  given(:question1) { user1.questions.first }
  given(:question2) { user1.questions.last }
  given(:question3) { user1.questions[1] }
  given!(:award1) { create(:award, :with_image, question: question1, user: user1) }
  given!(:award2) { create(:award, :with_image, question: question2, user: user2) }
  given!(:award_vacant) { create(:award, :with_image, question: question3, user: user1) }

  describe 'Authorized user' do
    background do
      sign_in(user2)
      visit awards_path
    end

    scenario 'can see his awards' do
      expect(page).to have_content award2.title
      expect(page).to have_css("img[src*='all_in_level.jpg']")
      expect(page).to have_link award2.question.title, href: question_path(question2)

      expect(page).not_to have_link award1.question.title, href: question_path(question1)
      expect(page).not_to have_link award_vacant.question.title, href: question_path(question3)
    end
  end

  describe 'Guest' do
    scenario 'can not see awards' do
      expect(page).not_to have_link 'Награды'
    end
  end
end
