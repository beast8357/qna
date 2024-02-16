require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  let!(:question) { create(:question, author: user, files: [file]) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'is the author of the question' do
        it 'can delete files' do
          expect do
            delete :destroy, params: { id: question.files.first }, format: :js
          end.to change(question.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'is not the author of the question' do
        let!(:question_2) { create(:question, author: create(:user), files: [file]) }

        it 'cannot delete files' do
          expect do
            delete :destroy, params: { id: question_2.files.first }, format: :js
          end.to_not change(question.files, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'cannot delete files' do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to_not change(question.files, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, params: {id: question.files.first}, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
