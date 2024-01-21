require 'rails_helper'

feature 'Authenticated user can answer the question', %q{
  As an authenticated user
  I'd like to be able to answer any question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to answer the question' do
      fill_in 'Body', with: 'Some answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'tries to answer the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank."
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'tries to answer the question' do
      fill_in 'Body', with: 'Some answer'
      click_on 'Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
