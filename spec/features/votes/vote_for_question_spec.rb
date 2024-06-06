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

      expect(page).to have_content "You don't have enough authority"
    end

    scenario 'can revote for the question' do
      within '.question' do
        find('.dislike').click
        find('.revote').click
        find('.like').click

        votes_sum_element = find('.votes-sum')
        expect(votes_sum_element).to have_text('1')
      end

      expect(question.reload.votes_sum).to eq(1)
    end

    scenario 'cannot see the revote button if did not vote' do
      within '.question' do
        expect(page).to_not have_selector('.revote')
      end
    end

    scenario 'cannot see the revote button after clicking on it' do
      within '.question' do
        find('.dislike').click
        find('.revote').click

        expect(page).to_not have_selector('.revote')
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'cannot see the like button' do
      within '.question' do
        expect(page).to_not have_selector('.like')
      end
    end

    scenario 'cannot see the dislike button' do
      within '.question' do
        expect(page).to_not have_selector('.dislike')
      end
    end

    scenario 'cannot see the revote button' do
      within '.question' do
        expect(page).to_not have_selector('.revote')
      end
    end
  end
end
