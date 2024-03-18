require 'rails_helper'

feature 'User can vote for the question', %q{
  In order to rate the question
  As an authenticated user
  I'd like to be able to vote for the question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can like the question' do
      within '.question' do
        find('.like').click

        votes_sum_element = find('.votes-sum')
        expect(votes_sum_element).to have_text(1)
      end

      expect(question.reload.votes_sum).to eq(1)
    end

    scenario 'can dislike the question' do
      within '.question' do
        find('.dislike').click

        votes_sum_element = find('.votes-sum')
        expect(votes_sum_element).to have_text(-1)
      end

      expect(question.reload.votes_sum).to eq(-1)
    end

    scenario 'cannot vote for their own question' do
      own_question = create(:question, author: user)
      visit question_path(own_question)

      within '.question' do
        find('.like').click
      end

      expect(page).to have_content "Author can't vote"
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'cannot see the like button' do
      expect(page).to_not have_selector('.like')
    end

    scenario 'cannot see the dislike button' do
      expect(page).to_not have_selector('.dislike')
    end
  end
end
