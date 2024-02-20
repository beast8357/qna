require 'rails_helper'

feature 'User can add links to their question', %q{
  In order to provide additional information to my question
  As the author of the question
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/beast8357/6bcb924bd58176ca38fdb8b43b7ea25a' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'can add links when asking a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
