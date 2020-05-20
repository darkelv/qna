require 'rails_helper'

describe 'Quest

ions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].last }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'return  200 status' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'return all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'return all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    let(:method) { :get }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      let!(:links) { create_list(:link, 2, linkable: question) }
      let(:link) { links.first }

      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let(:comment) { comments.first }

      let(:file) { question.files.first }

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
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it_behaves_like 'API Linkable' do
        let(:resource_response_with_links) { question_response['links'] }
      end

      it_behaves_like 'API Commentable' do
        let(:resource_response_with_comments) { question_response['comments'] }
      end

      it_behaves_like 'API Fileable' do
        let(:resource_response_with_files) { question_response['files'] }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    let(:method) { :post }
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      it_behaves_like 'API Create resource' do
        let(:klass) { Question }
        let(:attrs) { { title: 'Title', body: 'Body' } }
        let(:resource_response) { json['question'] }
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    let(:method) { :patch }
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      let(:attrs) { { title: 'NewHeader', body: 'NewContent' } }

      it_behaves_like 'API Update resource' do
        let(:klass) { Question }
        let(:resource_response) { json['question'] }
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    let(:method) { :delete }
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      it_behaves_like 'API Delete resource' do
        let(:klass) { Question }
      end
    end
  end
end
