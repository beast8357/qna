require 'rails_helper'

feature 'Authenticated user can answer the question', %q{
  As an authenticated user
  I'd like to be able to answer any question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to answer the question' do
      fill_in 'Your answer', with: 'Some answer'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'Some answer'
      end
    end

    scenario 'tries to answer the question with errors' do
      click_on 'Answer'
    end

    scenario 'creates an answer with attached files' do
      fill_in 'Your answer', with: 'Some answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'tries to answer the question' do
      fill_in 'Your answer', with: 'Some answer'
      click_on 'Answer'
    end
  end
end
