require 'rails_helper'

feature 'The answer can only be deleted by the author', %q{
  As the author of my answers
  And an authenticated user
  I'd like to be the only one who can delete my answers
} do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, author: users.first) }
  given(:answer) { create(:answer, question: question, author: users.first) }
  given(:answer_2) { create(:answer, question: question, author: users.last) }

  describe 'User' do
    background { sign_in(users.first) }

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
