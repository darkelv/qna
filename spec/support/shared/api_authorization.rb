shared_examples_for 'API Authorizable' do
  context 'unautarized' do
    it 'no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
      expect(response.body).to be_empty
    end
    it 'access_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
      expect(response.body).to be_empty
    end
  end
end
