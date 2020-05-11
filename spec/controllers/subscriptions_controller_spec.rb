require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user1) { create(:user_with_questions, questions_count: 1) }
  let(:user2) { create(:user) }
  let(:user1_question) { user1.questions.first }

  describe 'POST #create' do
    context 'as authorized not Subscriber' do
      before { login(user2) }

      it 'saves a new subscription for user in the database' do
        expect { post :create, params: { question_id: user1_question, format: :js } }
          .to change(Subscription, :count).by(1)
      end

      it 'saves as the subscription of correct question and user' do
        post :create, params: { question_id: user1_question, format: :js }

        created_subscription = Subscription.order(:created_at).last
        expect(created_subscription.question).to eq(user1_question)
        expect(created_subscription.user).to eq(user2)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: user1_question, format: :js }

        expect(response).to render_template :create
      end
    end

    context 'as authorized Subscriber' do
      let!(:subscription) { create(:subscription, question: user1_question, user: user2) }

      before { login(user2) }

      it 'does not save the subscription for user' do
        expect { post :create, params: { question_id: user1_question, format: :js } }
          .not_to change(Subscription, :count)
      end
    end

    context 'as Guest' do
      it 'does not save the subscription for user' do
        expect { post :create, params: { question_id: user1_question, format: :js } }
          .not_to change(Subscription, :count)
      end

      it 'returns no-authenticate response' do
        post :create, params: { question_id: user1_question, format: :js }

        expect(response.status).to eq 401
        expect(response.body).to eq I18n.t('devise.failure.unauthenticated')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user3) { create(:user) }
    let!(:subscription) { create(:subscription, question: user1_question, user: user2) }

    context 'as authorized Subscriber' do
      before { login(user2) }

      it 'deletes the subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }
          .to change(Subscription, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: subscription, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'as authorized no Subscriber' do
      before { login(user3) }

      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }
          .not_to change(Subscription, :count)
      end

      it 'returns 403 error' do
        delete :destroy, params: { id: subscription, format: :js }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'as Guest' do
      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }
          .not_to change(Subscription, :count)
      end

      it 'no-authenticate response' do
        delete :destroy, params: { id: subscription, format: :js }

        expect(response.status).to eq 401
        expect(response.body).to eq I18n.t('devise.failure.unauthenticated')
      end
    end
  end
end
