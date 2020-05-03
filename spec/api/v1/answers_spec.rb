require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before do
        do_request(
          method, api_path,
          params: { access_token: access_token.token },
          headers: headers
        )
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body user_id question_id best rating created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains answer object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end

      it 'contains short body' do
        expect(answer_response['short_body']).to eq answer.body.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_files) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      let!(:links) { create_list(:link, 2, linkable: answer) }
      let(:link) { links.first }

      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let(:comment) { comments.first }

      let(:file) { answer.files.first }

      before do
        do_request(
          method, api_path,
          params: { access_token: access_token.token },
          headers: headers
        )
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it_behaves_like 'API Linkable' do
        let(:resource_response_with_links) { answer_response['links'] }
      end

      it_behaves_like 'API Commentable' do
        let(:resource_response_with_comments) { answer_response['comments'] }
      end

      it_behaves_like 'API Fileable' do
        let(:resource_response_with_files) { answer_response['files'] }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    let(:method) { :post }
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      it_behaves_like 'API Create resource' do
        let(:klass) { Answer }
        let(:attrs) { { body: 'Body' } }
        let(:resource_response) { json['answer'] }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    let(:method) { :patch }
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:attrs) { { body: 'NewContent' } }

      it_behaves_like 'API Update resource' do
        let(:klass) { Answer }
        let(:resource_response) { json['answer'] }
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    let(:method) { :delete }
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      it_behaves_like 'API Delete resource' do
        let(:klass) { Answer }
      end
    end
  end
end
