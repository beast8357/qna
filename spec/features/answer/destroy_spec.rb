require 'rails_helper'

feature 'The answer can only be deleted by the author', %q{
  As the author of my answers
  And an authenticated user
  I'd like to be the only one who can delete my answers
} do
  given!(:users) { create_list(:user, 3) }
  given(:question) { create(:question, author: users.first) }
  given!(:answer_1) { create(:answer, question: question, author: users[0]) }
  given!(:answer_2) { create(:answer, question: question, author: users[1]) }

  describe 'Authenticated user', js: true do
    scenario 'tries to delete their own answer' do
      sign_in(users[0])
      visit question_path(question)

      within '.answers' do
        click_on 'Delete'

        expect(page).to_not have_link 'Delete'
      end
    end

    scenario "cannot delete someone else's answer" do
      sign_in(users[2])
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Delete'
      end
    end
  end
end
