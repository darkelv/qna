shared_examples 'API Fileable' do
  context 'files' do
    it 'returns resource with files' do
      expect(resource_response_with_files.size).to eq 2
    end

    it 'returns all public fields of resource file' do
      expect(resource_response_with_files.first['id']).to eq file.id
      expect('http://www.example.com' + resource_response_with_files.first['url']).to eq url_for(file).as_json
    end
  end
end
