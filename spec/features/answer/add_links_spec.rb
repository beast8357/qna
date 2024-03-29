require 'rails_helper'

feature 'User can add links to their answer', %q{
  In order to provide additional information to my answer
  As the author of the answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/beast8357/6bcb924bd58176ca38fdb8b43b7ea25a' }
  given(:google_url) { 'https://www.google.com' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      within '.answer-form' do
        fill_in 'Your answer', with: 'Some answer'

        click_on 'Add link'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end
    end

    scenario 'can add a link when creating an answer' do
      within '.answer-form' do
        click_on 'Answer'
      end

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end

      expect(page).to_not have_content 'Link name'
      expect(page).to_not have_content 'Url'
    end

    scenario 'can add multiple links when creating an answer' do
      within '.answer-form' do
        click_on 'Add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'Google'
          fill_in 'Url', with: google_url
        end

        click_on 'Answer'
      end

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'Google', href: google_url
        expect(page).to_not have_content 'Link name'
        expect(page).to_not have_content 'Url'
      end
    end

    scenario 'can add gists when creating an answer' do
      click_on 'Answer'

      within_frame find("iframe.gist-content") do
        expect(page).to have_content 'gistfile1.txt'
        expect(page).to have_content 'Hello world'
      end
    end

    scenario 'can add links when editing their answer' do
      click_on 'Answer'

      within '.answers' do
        click_on 'Edit'
      end

      within '.answer-edit' do
        click_on 'Add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'GitHub'
          fill_in 'Url', with: 'https://github.com/'
        end

        click_on 'Save'
      end

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'GitHub', href: 'https://github.com/'
    end

    scenario 'can delete links when editing the answer' do
      click_on 'Answer'

      within '.answers' do
        click_on 'Edit'
      end

      within '.answer-edit' do
        click_on 'Remove url'
      end

      click_on 'Save'

      expect(page).to_not have_link 'My gist', href: gist_url
    end
  end
end
