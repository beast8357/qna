require 'rails_helper'

feature 'User can sign up', %q{
  In order to have the ability to authenticate
  As an unregistered user
  I'd like to be able to sign up
} do
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  describe 'Unregistered user' do
    scenario 'tries to sign up' do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'qweqwe'
      fill_in 'Password confirmation', with: 'qweqwe'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'tries to sign up with invalid email' do
      fill_in 'Email', with: 'userEmail.com'
      fill_in 'Password', with: 'qweqwe'
      fill_in 'Password confirmation', with: 'qweqwe'
      click_on 'Sign up'

      expect(page).to have_content 'Email is invalid'
    end

    scenario 'tries to sign up with invalid password' do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'qwe'
      fill_in 'Password confirmation', with: 'qwe'
      click_on 'Sign up'

      expect(page).to have_content 'Password is too short'
    end

    scenario 'tries to sign up with invalid password confirmation' do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'qweqwe'
      fill_in 'Password confirmation', with: 'qweqweqwe'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'qweqwe'
    fill_in 'Password confirmation', with: 'qweqwe'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
