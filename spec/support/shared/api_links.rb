shared_examples 'API Linkable' do
  context 'links' do
    it 'returns resource with links' do
      expect(resource_response_with_links.size).to eq 2
    end

    it 'returns all public fields link' do
      %w[id url].each do |attr|
        expect(resource_response_with_links.last[attr]).to eq link.send(attr).as_json
      end
    end
  end
end
