require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end

      it 'creates answer with logged-in user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user).to eq(user)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.not_to change(question.answers, :count)
      end

      it 'to question page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  # describe 'GET #edit' do
  #   let(:answer) { create(:answer, user: user, question: question) }
  #
  #   before do
  #     get :edit, params: { question_id: question, id: answer, format: :js }
  #   end
  #
  #   it 'assigns the requested answer to @answer' do
  #     expect(assigns(:answer)).to eq(answer)
  #   end
  #
  #   it 'renders edit view' do
  #     expect(response).to render_template :edit
  #   end
  #
  #   it 'does not allow to edit for other user' do
  #     answer = create(:answer)
  #
  #     get :edit, params: { question_id: question, id: answer }
  #
  #     expect(response).to redirect_to question
  #   end
  # end
  #
  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to the updated answer question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end

      it 'does not allow to update for other user' do
        answer = create(:answer)

        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        end.to_not change(answer, :body)
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        initial_text = answer.body
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid),  format: :js }
        answer.reload
        expect(answer.body).to eq initial_text
      end

      it 'rerenders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with correct user' do
      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question view' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'with incorrect user' do
      let(:incorrect_user) { create(:user) }

      before { login(incorrect_user) }

      it 'does not allow to destroy' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.not_to change(question.answers, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question
      end
    end
  end
end

