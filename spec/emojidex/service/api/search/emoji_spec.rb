#require 'spec_helper'
#
#describe Emojidex::API::Search::Emoji do
#  subject { Emojidex::Client.new(host: 'http://localhost') }
#  let!(:api_url) { 'http://localhost/api/v1' }
#
#  describe '#emoji' do
#    before do
#      stub_get("#{api_url}/search/emoji.json")
#        .with(query: { 'q[code_cont]' => 't' })
#        .to_return(
#                    body: fixture('search_emoji.json'),
#                    headers: { content_type: 'application/json' }
#                  )
#    end
#
#    it 'requests the correct resource' do
#      subject.emoji_code_cont('t')
#      expect(a_get("#{api_url}/search/emoji.json")
#        .with(query: { 'q[code_cont]' => 't' })).to have_been_made
#    end
#
#    it 'returns the requested search' do
#      results = subject.emoji_code_cont('t')
#      expect(results).to be_an Array
#      expect(results.first).to be_a Hash
#    end
#  end
#
#end
