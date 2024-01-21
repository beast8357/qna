require 'rails_helper'

feature 'The question can only be deleted by the author', %q{
  As the author of my questions
  And an authenticated user
  I'd like to be the only one who can delete my questions
} do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, author: users.first) }
  given(:question_2) { create(:question, author: users.last) }

  describe 'User' do
    background { sign_in(users.first) }

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
