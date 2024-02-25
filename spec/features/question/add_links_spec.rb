require 'rails_helper'

feature 'User can add links to their question', %q{
  In order to provide additional information to my question
  As the author of the question
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/beast8357/6bcb924bd58176ca38fdb8b43b7ea25a' }
  given(:google_url) { 'https://www.google.com' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'can add a link when asking a question' do
      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'can add multiple links when asking a question' do
      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Google', href: google_url
    end
  end
end
