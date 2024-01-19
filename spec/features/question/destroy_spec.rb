require 'rails_helper'

feature 'The question can only be deleted by the author', %q{
  As the author of my questions
  And an authenticated user
  I'd like to be the only one who can delete my questions
} do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:question_2) { create(:question, author: user_2) }

  describe 'User' do
    background { sign_in(user) }

    scenario 'tries to delete their own question' do
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'The question has been successfully deleted.'
    end

    scenario "tries to delete someone else's question" do
      visit question_path(question_2)

      expect(page).to_not have_content 'Delete'
    end
  end
end
