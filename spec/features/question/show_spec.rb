require 'rails_helper'

feature 'User can view the question and the answers to it', %q{
  As any user
  I'd like to be able to view the question
  And view the answers to that question on the same page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answers) { create_list(:answer, 3, question: question, author: user) }

  describe 'User' do
    background { visit question_path(question) }

    scenario 'tries to view the question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'tries to view the answers to the question' do
      expect(page).to have_content answers[0].body
      expect(page).to have_content answers[1].body
      expect(page).to have_content answers[2].body
    end
  end
end
