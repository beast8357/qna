require 'rails_helper'

feature 'User can add a reward to their question', %q{
  In order to thank people
  As the author of my question
  I'd like to be able to reward for the best answer to my question
} do
  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given(:reward_image) { "#{Rails.root}/spec/files/reward.png" }
    given(:invalid_reward_image) { "#{Rails.root}/spec/files/invalid_reward.pdf" }

    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'Add reward'
    end

    scenario 'can add a reward to their question' do
      within '.reward' do
        fill_in 'Reward title', with: 'Good job!'
        attach_file reward_image
      end

      click_on 'Ask'

      expect(page).to have_content 'Good job!'
    end

    scenario 'cannot add a reward with no attached image' do
      within '.reward' do
        fill_in 'Reward title', with: 'Good job!'
      end

      click_on 'Ask'

      expect(page).to have_content 'Reward image must be present'
    end

    scenario 'cannot add a reward with an attached file that is not an image' do
      within '.reward' do
        fill_in 'Reward title', with: 'Good job!'
      end

      click_on 'Ask'

      expect(page).to have_content 'Reward image must be present'
    end
  end
end
