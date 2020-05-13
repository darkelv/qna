require 'rails_helper'

describe SearchController, type: :controller do
  let!(:questions) { create_list(:question, 2) }

  describe 'GET #index' do
    before do
      allow(SearchService).to receive(:call).and_call_original
      allow(SearchService)
        .to receive(:call).with('keywords' => 'some', 'resource' => 'any')
              .and_return(questions)

      get :index, params: { search: { keywords: 'some', resource: 'any' } }
    end

    it 'populates an array of all resources' do
      expect(assigns(:search_result)).to match_array(questions)
      expect(assigns(:keywords)).to eq 'some'
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
