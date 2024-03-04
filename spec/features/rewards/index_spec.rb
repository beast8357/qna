require 'rails_helper'

feature 'User can view the list of their rewards', %q{
  In order to see what rewards I've got
  As an authenticated user
  I'd like to be able to view the list of all rewards that I have
} do
  given(:user) { create(:user) }
  given(:question_1) { create(:question, author: user) }
  given(:question_2) { create(:question, author: user) }
  given(:answer_1) { create(:answer, question: question_1, author: user) }
  given(:answer_2) { create(:answer, question: question_2, author: user) }
  given(:reward_image) { "#{Rails.root}/spec/files/reward.png" }

  background do
    create(:reward,
           title: 'Reward 1',
           image: Rack::Test::UploadedFile.new(reward_image),
           question: question_1,
           answer: answer_1)

    create(:reward,
           title: 'Reward 2',
           image: Rack::Test::UploadedFile.new(reward_image),
           question: question_2,
           answer: answer_2)

    sign_in(user)
    visit rewards_path
  end

  scenario 'Authenticated user can view the list of all their rewards' do
    user.rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_css "img[src*='#{reward.image.filename}']"
      expect(page).to have_content reward.title
    end
  end
end
