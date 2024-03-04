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

    scenario 'can add gists when asking a question' do
      click_on 'Ask'

      within_frame find("iframe.gist-content") do
        expect(page).to have_content 'gistfile1.txt'
        expect(page).to have_content 'Hello world'
      end
    end

    scenario 'can add links when editing the question' do
      click_on 'Ask'

      click_on 'Edit question'

      within '.question-control' do
        click_on 'Add link'
      end

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'GitHub'
        fill_in 'Url', with: 'https://github.com/'
      end

      click_on 'Save'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'GitHub', href: 'https://github.com/'
    end

    scenario 'can delete links when editing the question' do
      click_on 'Ask'

      click_on 'Edit question'

      within '.question-control' do
        click_on 'Remove url'
      end

      click_on 'Save'

      expect(page).to_not have_link 'My gist', href: gist_url
    end
  end
end
