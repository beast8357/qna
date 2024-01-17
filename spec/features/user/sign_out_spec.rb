require 'rails_helper'

feature 'User can sign out', %q{
  In order to finish current user session
  As an authenticated user
  I'd like to be able to sign out
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_user_session_path
  end

  scenario 'Authenticated user tries to sign out' do
    click_on 'Log Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
