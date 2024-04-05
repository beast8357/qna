require 'rails_helper'

feature 'User can leave comments on answers', %q{
  In order to offer advice
  As an authenticated user
  I'd like to be able to leave comments on the answer
} do
  given!(:user) { create(:user) }
  given!(:guest) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    context 'multiple sessions' do
      scenario "the comment appears on another user's page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          within "#answer_#{answer.id}" do
            expect(page).to_not have_selector('.comment')
            expect(page).to have_selector('.add-comment')
          end
        end

        Capybara.using_session('guest') do
          visit question_path(question)

          within "#answer_#{answer.id}"  do
            expect(page).to_not have_selector('.comment')
          end
        end

        Capybara.using_session('user') do
          within "#answer_#{answer.id}" do
            fill_in 'Your comment', with: 'answer comment'
            click_on 'Comment'
          end

          within "#answer_#{answer.id} .comments" do
            expect(page).to have_content("Comment by #{user.email}")
            expect(page).to have_content('answer comment')
          end
        end

        Capybara.using_session('guest') do
          within "#answer_#{answer.id} .comments" do
            expect(page).to have_content("Comment by #{user.email}")
            expect(page).to have_content('answer comment')
          end
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'cannot see the form for adding comments' do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector('.add-comment')
      end
    end
  end
end
