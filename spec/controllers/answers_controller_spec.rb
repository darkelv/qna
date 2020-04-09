require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3) }

    before { get :index, params: { question_id: question } }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #edit' do
    let(:answer) { create(:answer, user: user) }

    before do
      get :edit, params: { question_id: question, id: answer }
    end

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'does not allow to edit for other user' do
      answer = create(:answer)

      get :edit,  params: { question_id: question, id: answer }

      expect(response).to redirect_to question
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }

        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATH #update' do
    let(:answer) { create(:answer, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body'} }
        answer.reload

        expect(answer.body).to eq 'new body'

      end
      it 'redirect update answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end

      it 'does not allow to update for other user' do
        answer = create(:answer)

        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: {  question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }
      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    before { login(user) }

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
end
