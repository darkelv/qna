require 'rails_helper'

describe SearchService do
  context 'with resource' do
    it 'search in one resource' do
      SearchService::RESOURCES.keys.each do |resource|
        search_params = { keywords: 'myContent', resource: resource }
        resource_klass = resource.to_s.capitalize.constantize

        expect(resource_klass)
          .to receive(:search)
                .with(search_params[:keywords])
                .and_call_original

        SearchService.call(search_params)
      end
    end
  end

  context 'without resource' do
    let(:search_params) { { keywords: 'myContent', resource: 'all' } }

    it 'search in all resources' do
      expect(ThinkingSphinx).to receive(:search).with(search_params[:keywords]).and_call_original

      SearchService.call(search_params)
    end
  end
end
