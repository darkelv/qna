require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  before { login(question.user) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3) }

    before { get :index, params: { question_id: question } }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new , params: { question_id: question}}

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { question_id: question, id: answer } }

    it 'renders edit view' do
      expect(response).to render_template :edit
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
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATH #update' do
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { title: 'new title', body: 'new body'} }
        answer.reload

        expect(answer.title).to eq 'new title'
        expect(answer.body).to eq 'new body'

      end
      it 'redirect update answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: {  question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.title).to eq 'MyString'
        expect(answer.body).to eq 'MyText'
      end
      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: question.user) }

    it 'delete the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end
    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
