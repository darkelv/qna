shared_examples 'API Create resource' do
  let(:access_token) { create(:access_token) }
  let(:resource_sym) { klass.to_s.underscore.to_sym }

  context 'with valid attributes' do
    let(:saved_resource) { klass.first }

    it 'returns 201 status' do
      do_request(
        method, api_path, params: {
        access_token: access_token.token,
        resource_sym => attributes_for(resource_sym)
      }, headers: headers
      )
      expect(response).to be_successful
    end

    it 'saves a new resource in the database' do
      expect do
        do_request(
          method, api_path, params: {
          access_token: access_token.token,
          resource_sym => attributes_for(resource_sym)
        }, headers: headers
        )
      end
        .to change(klass, :count).by(1)
    end

    it 'saves as the resource with correct attributes' do
      do_request(
        method, api_path, params: {
        access_token: access_token.token,
        resource_sym => attrs
      }, headers: headers
      )
      expect(saved_resource.user_id).to eq(access_token.resource_owner_id)
      attrs.each do |key, value|
        expect(saved_resource[key]).to eq(value)
      end
    end

    it 'returns all public fields of resource' do
      do_request(
        method, api_path, params: {
        access_token: access_token.token,
        resource_sym => attrs
      }, headers: headers
      )
      ['created_at', 'updated_at', *attrs.keys].each do |attr|
        expect(resource_response[attr.to_s]).to eq saved_resource.send(attr).as_json
      end
    end
  end

  context 'with invalid attributes' do
    it 'returns 422 status' do
      do_request(
        method, api_path, params: {
        access_token: access_token.token,
        resource_sym => attributes_for(resource_sym, :invalid)
      }, headers: headers
      )
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not save resource in the database' do
      expect do
        do_request(
          method, api_path, params: {
          access_token: access_token.token,
          resource_sym => attributes_for(resource_sym, :invalid)
        }, headers: headers
        )
      end
        .to_not change(klass, :count)
    end

    it 'returns error' do
      do_request(
        method, api_path, params: {
        access_token: access_token.token,
        resource_sym => { body: nil }
      }, headers: headers
      )
      expect(json['body']).to include "can't be blank"
    end
  end
end
