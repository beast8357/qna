require 'rails_helper'

feature 'User can leave comments on questions', %q{
  In order to offer advice
  As an authenticated user
  I'd like to be able to leave comments on the question
} do
  given!(:user) { create(:user) }
  given!(:guest) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    context 'multiple sessions' do
      scenario "the comment appears on another user's the page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          within '.question' do
            expect(page).to_not have_selector('.comment')
            expect(page).to have_selector('.add-comment')
          end
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within '.question' do
            fill_in 'Your comment', with: 'question comment'
            click_on 'Save'
          end

          within '.question .comments' do
            expect(page).to have_content("Comment by #{user.email}")
            expect(page).to have_content('question comment')
          end
        end

        Capybara.using_session('guest') do
          within '.question .comments' do
            expect(page).to have_content("Comment by #{user.email}")
            expect(page).to have_content('question comment')
          end
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'cannot see the form for adding comments' do
      within '.question' do
        expect(page).to_not have_selector('.add-comment')
      end
    end
  end
end
