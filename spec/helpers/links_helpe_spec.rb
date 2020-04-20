require 'rails_helper'

describe LinksHelper, type: :helper do
  let!(:raw_gist) { 'file1.txt---Ruby on Rails***file2.txt---Best framework' }
  let!(:parsed_gist) { '<p>file1.txt<br>Ruby on Rails</p><p>file2.txt<br>Best framework</p>' }

  it 'link_gist should parse string into html' do
    expect(link_gist(raw_gist)).to match parsed_gist
  end
end
