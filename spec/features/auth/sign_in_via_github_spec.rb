require 'rails_helper'

feature 'User can sing in via github', %q{
  In order to choose the most convenient way to sing in
  As an unauthenticated user
  I'd like to be able to sign in via github
} do
  describe 'access top page' do
    it 'can sing the user in with GitHub account' do
      visit new_user_session_path

      github_mock_auth_hash

      click_button 'Sign in with GitHub'

      within '.notice' do
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      expect(page).to have_content 'Log Out'
    end

    it 'can handle authentication error' do
      visit new_user_session_path

      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      click_button 'Sign in with GitHub'

      expect(page).to have_content "Could not authenticate you from GitHub because \"Invalid credentials\""
    end
  end
end
