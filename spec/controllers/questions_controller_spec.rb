require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { login(user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assign Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assign link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'save a question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
    end

    it 'creates question with logged-in user' do
      post :create, params: { question: attributes_for(:question) }
      expect(assigns(:question).user).to eq(user)
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATH #update' do
    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'

      end
      it 'redirect update question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
    end

    context 'with incorrect user' do
      before do
        question.user = create(:user)
        question.save!
      end

      it 'does not change question attributes' do
        old_title = question.title
        patch :update, params: { id: question, question: { title: 'wrong title' } }
        question.reload
        expect(question.title).to eq old_title
      end

      it 'forbidden to question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to be_forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context 'with correct user' do
      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with incorrect user' do
      let(:incorrect_user) { create(:user) }

      before { login(incorrect_user) }

      it 'does not allow to destroy' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'forbidden to question' do
        delete :destroy, params: { id: question }
        expect(response).to be_forbidden
      end
    end
  end
end
