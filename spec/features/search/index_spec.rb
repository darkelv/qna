require 'sphinx_helper'

feature 'Guest can use search' do
  given!(:question1) { create(:question, body: 'correct q one') }
  given!(:question2) { create(:question, body: 'correct q two') }
  given!(:question3) { create(:question, body: 'another q three') }

  given!(:answer1) { create(:answer, body: 'correct a one') }
  given!(:answer2) { create(:answer, body: 'correct a two') }
  given!(:answer3) { create(:answer, body: 'another a three') }

  given!(:comment1) { create(:comment, commentable: question1, body: 'correct c one') }
  given!(:comment2) { create(:comment, commentable: question2, body: 'correct c two') }
  given!(:comment3) { create(:comment, commentable: answer2, body: 'another c three') }

  background { visit questions_path }

  describe 'Resource search completes successfully', sphinx: true do
    scenario 'in separate resources' do
      mapping = {
        "question" => [[question1, question2], question3],
        "answer" => [[answer1, answer2], answer3],
        "comment" => [[comment1, comment2], comment3]
      }

      mapping.each do |resource_name, resources|
        ThinkingSphinx::Test.run do
          search_in('correct', resource_name)

          resources.first.each { |resource| expect(page).to have_content(resource.body) }
          expect(page).not_to have_content(resources.last.body)
        end
      end
    end
  end

  describe 'Resource search failed', sphinx: true do
    scenario 'when finding nothing' do
      [:question, :answer, :comment].each do |resource|
        ThinkingSphinx::Test.run do
          search_in('testeing_word', resource)

          expect(page).to have_content("Nothing has been found")
        end
      end
    end
  end

  describe 'Global search', sphinx: true do
    scenario 'completes successfully' do
      ThinkingSphinx::Test.run do
        search_in('another')

        [question3, answer3, comment3]
          .each { |resource| expect(page).to have_content(resource.body) }

        [question1, answer1, comment1]
          .each { |resource| expect(page).not_to have_content(resource.body) }
      end
    end

    scenario 'has found nothing' do
      ThinkingSphinx::Test.run do
        search_in('trulyly')

        expect(page).to have_content("Nothing has been found")
      end
    end
  end

  scenario 'Query has empty' do
    ThinkingSphinx::Test.run do
      search_in('   ')

      expect(page).to have_content("Your request is empty")
    end
  end
end
