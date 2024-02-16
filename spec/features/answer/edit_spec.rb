require 'rails_helper'

feature 'User can edit their answer', %q{
  In order to correct mistakes
  As the author of the answer
  I'd like to be able to edit my answer
} do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author: users.first) }
  given!(:answer) { create(:answer, question: question, author: users.first) }

  scenario 'Unauthenticated user cannot edit the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'tries to edit their answer' do
      sign_in(users.first)
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit their answer with errors' do
      sign_in(users.first)
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "cannot edit someone else's answers" do
      sign_in(users.last)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'can attach file when editing the answer' do
      sign_in(users.first)
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'Edited answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
