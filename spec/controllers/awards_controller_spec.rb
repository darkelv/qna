require 'rails_helper'

describe AwardsController, type: :controller do
  let(:user1) { create(:user_with_questions) }
  let(:user2) { create(:user) }
  let(:question1) { user1.questions.first }
  let(:question2) { user1.questions.last }
  let!(:award1) { create(:award, :with_image, question: question1, user: user1) }
  let!(:award2) { create(:award, :with_image, question: question2, user: user2) }

  describe 'GET #index' do
    context 'as authorized Author' do
      before { sign_in(user2) and get :index }

      it 'populates an array of hes awards' do
        expect(assigns(:awards)).to match_array([award2])
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'As a Guest' do
      it 'redirect to new session' do
        get :index

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
