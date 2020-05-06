shared_examples 'API Delete resource' do
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  it 'returns 200 status' do
    do_request(
      method, api_path,
      params: { access_token: access_token.token },
      headers: headers
    )
    expect(response).to be_successful
  end

  it 'deletes resource from the database' do
    expect do
      do_request(
        method, api_path,
        params: { access_token: access_token.token },
        headers: headers
      )
    end
      .to change(klass, :count).by(-1)
  end
end
