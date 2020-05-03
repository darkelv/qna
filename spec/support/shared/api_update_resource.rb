shared_examples 'API Update resource' do
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:resource_sym) { klass.to_s.underscore.to_sym }

  context 'with valid attributes' do
    let(:saved_resource) { klass.first }

    before do
      do_request(
        method, api_path, params: {
        access_token: access_token.token,
        resource_sym => attrs
      }, headers: headers
      )
    end

    it 'returns 200 status' do
      expect(response).to have_http_status :ok
    end

    it 'update the resource with correct attributes' do
      attrs.each do |key, value|
        expect(saved_resource[key]).to eq(value)
      end
    end

    it 'returns all public fields of resource' do
      ['created_at', 'updated_at', *attrs.keys].each do |attr|
        expect(resource_response[attr.to_s]).to eq saved_resource.send(attr).as_json
      end
    end
  end

  context 'with invalid attributes' do
    before do
      do_request(
        method, api_path, params: {
        access_token: access_token.token,
        resource_sym => { body: nil }
      }, headers: headers
      )
    end

    it 'returns 422 status' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error' do
      expect(json['body']).to include "can't be blank"
    end
  end
end
