require 'rails_helper'

feature 'User can answer the question', %q{
  As any user
  I'd like to be able to answer any question
} do
  given(:question) { create(:question) }

  describe 'User' do
    background do
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
end
