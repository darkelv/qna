require 'rails_helper'

describe LinksController, type: :controller do
  let(:user1) { create(:user_with_questions, questions_count: 1) }
  let(:user2) { create(:user) }
  let!(:question) { user1.questions.first }

  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'as authorized Author' do
      before { login(user1) }

      it 'deletes link from his question' do
        expect { delete :destroy, params: { id: link, format: :js } }
          .to change(Link, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: link, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'as authorized no Author' do
      before { login(user2) }

      it 'does not delete link from not his question' do
        expect { delete :destroy, params: { id: link, format: :js } }
          .to_not change(Link, :count)
      end

      it 'try destroy links' do
        delete :destroy, params: { id: link, format: :js }

        expect(response).to be_forbidden
      end
    end

    context 'as Guest' do
      it 'does not delete link from the question' do
        expect { delete :destroy, params: { id: link, format: :js } }
          .to_not change(Link, :count)
      end
    end
  end
end
