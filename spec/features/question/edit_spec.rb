require 'rails_helper'

feature 'User can edit their question', %q{
  In order to correct mistakes
  As the author of the question
  I'd like to be able to edit my question
} do
  given!(:users) { create_list(:user, 2) }
  given!(:question_1) { create(:question, author: users.first) }
  given!(:question_2) { create(:question, author: users.last) }

  scenario 'Unauthenticated user cannot edit the question' do
    visit question_path(question_1)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    background { sign_in(users.first) }

    scenario 'tries to edit their question' do
      visit question_path(question_1)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question_1.title
        expect(page).to_not have_content question_1.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'input'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit their question with errors' do
      visit question_path(question_1)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to_not have_content 'edited title'
        expect(page).to_not have_content 'edited body'
        expect(page).to have_selector 'input'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit someone else's question" do
      visit question_path(question_2)

      expect(page).to_not have_link 'Edit question'
    end

    scenario 'can attach files when editing the question' do
      visit question_path(question_1)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'can delete files attached to the question' do
      visit question_path(question_1)
      click_on 'Edit question'

      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      within '.question-files' do
        first('.attachment').click_on 'Delete file'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end
  end
end
