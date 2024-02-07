require 'rails_helper'

feature 'User can edit their answer', %q{
  In order to correct mistakes
  As the author of the answer
  I'd like to be able to edit my answer
} do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author: users.first) }
  given!(:answer) { create(:answer, question: question, author: users.first) }

  scenario 'Unauthenticated user cannot edit the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(users.first)
      visit question_path(question)
    end

    scenario 'tries to edit their answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit their answer with errors'
    scenario "tries to edit someone else's answer"
  end
end
