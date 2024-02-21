require 'rails_helper'

feature 'User can add links to their answer', %q{
  In order to provide additional information to my answer
  As the author of the answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/beast8357/6bcb924bd58176ca38fdb8b43b7ea25a' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can add links when creating an answer' do
      fill_in 'Your answer', with: 'Some answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end
  end
end
