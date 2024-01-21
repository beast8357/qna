require 'rails_helper'

feature 'The answer can only be deleted by the author', %q{
  As the author of my answers
  And an authenticated user
  I'd like to be the only one who can delete my answers
} do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:question_2) { create(:question, author: user_2) }
  given(:answer) { create(:answer, question: question, author: user) }
  given(:answer_2) { create(:answer, question: question, author: user_2) }

  describe 'User' do
    background { sign_in(user) }

    scenario 'tries to delete their own answer' do
      visit question_answer_path(question, answer)
      click_on 'Delete'

      expect(page).to have_content 'The answer has been successfully deleted.'
    end

    scenario "tries to delete someone else's answer" do
      visit question_answer_path(question, answer_2)
      
      expect(page).to_not have_content 'Delete'
    end
  end
end
