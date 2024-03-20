require 'rails_helper'

feature 'User can vote for the answer', %q{
  In order to rate the answer
  As an authenticated user
  I'd like to be able to vote for the answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:own_answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can like the answer' do
      within "#answer_#{answer.id}" do
        find('.like').click

        votes_sum_element = find('.votes-sum')
        expect(votes_sum_element).to have_text('1')
      end

      expect(answer.reload.votes_sum).to eq(1)
    end

    scenario 'can dislike the answer' do
      within "#answer_#{answer.id}" do
        find('.dislike').click

        votes_sum_element = find('.votes-sum')
        expect(votes_sum_element).to have_text('-1')
      end

      expect(answer.reload.votes_sum).to eq(-1)
    end

    scenario 'cannot vote for their own answer' do
      within "#answer_#{own_answer.id}" do
        find('.like').click
      end

      expect(page).to have_content "Author can't vote"
    end

    scenario 'can revote for the answer' do
      within "#answer_#{answer.id}" do
        find('.dislike').click
        find('.revote').click
        find('.like').click

        votes_sum_element = find('.votes-sum')
        expect(votes_sum_element).to have_text('1')
      end

      expect(answer.reload.votes_sum).to eq(1)
    end

    scenario 'cannot see the revote button if did not vote' do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector('.revote')
      end
    end

    scenario 'cannot see the revote button after clicking on it' do
      within "#answer_#{answer.id}" do
        find('.dislike').click
        find('.revote').click

        expect(page).to_not have_selector('.revote')
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'cannot see the like button' do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector('.like')
      end
    end

    scenario 'cannot see the dislike' do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector('.dislike')
      end
    end

    scenario 'cannot see the revote button' do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector('.revote')
      end
    end
  end
end
