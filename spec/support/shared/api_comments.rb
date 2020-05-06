shared_examples 'API Commentable' do
  context 'comments' do
    it 'returns resource with comments' do
      expect(resource_response_with_comments.size).to eq 2
    end

    it 'returns all public fields of resource comment' do
      %w[id body].each do |attr|
        expect(resource_response_with_comments.last[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
