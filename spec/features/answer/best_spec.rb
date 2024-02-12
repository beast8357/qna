require 'rails_helper'

feature 'User can mark the best answer to the question', %q{
  In order to mark the most useful solution of the problem
  As an authenticated user
  I'd like to be able to mark the best answer
} do
  given(:users) { create_list(:user, 3) }
  given(:question) { create(:question, author: users[0]) }
  given!(:answer_1) { create(:answer, question: question, author: users[0]) }
  given!(:answer_2) { create(:answer, question: question, author: users[1]) }

  scenario 'Unauthenticated user cannot mark the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as the best'
  end

  describe 'Authenticated user', js: true do
    scenario 'marks the best answer for the first time' do
      sign_in(users[0])
      visit question_path(question)

      within "#answer_#{answer_2.id}" do
        click_on 'Mark as the best'

        expect(page).to have_content answer_2.body
        expect(page).to_not have_link 'Mark as the best'
      end  
    end

    scenario 'marks the other answer as the best'
    scenario "cannot mark the best answer to other user's question"
  end
end
