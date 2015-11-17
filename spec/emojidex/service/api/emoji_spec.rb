#require 'spec_helper'
#
#describe Emojidex::API::Emoji do
#  subject { Emojidex::Client.new(host: 'http://localhost') }
#  let!(:api_url) { 'http://localhost/api/v1' }
#
#  describe '#emoji' do
#    before do
#      stub_get("#{api_url}/emoji.json")
#        .to_return(
#                    body: fixture('emoji.json'),
#                    headers: { content_type: 'application/json' }
#                  )
#    end
#
#    it 'requests the correct resource' do
#      subject.emoji
#      expect(a_get("#{api_url}/emoji.json")).to have_been_made
#    end
#
#    it 'returns the requested emoji' do
#      emoji = subject.emoji
#      expect(emoji).to be_an Array
#      expect(emoji.first).to be_a Hash
#    end
#  end
#
#  describe '#emoji_detailed' do
#    before do
#      stub_get("#{api_url}/emoji/detailed.json")
#        .to_return(
#                    body: fixture('emoji_detailed.json'),
#                    headers: { content_type: 'application/json' }
#                  )
#    end
#
#    it 'requests the correct resource' do
#      subject.emoji_detailed
#      expect(a_get("#{api_url}/emoji/detailed.json")).to have_been_made
#    end
#
#    it 'returns the requested emoji' do
#      emoji = subject.emoji_detailed
#      expect(emoji).to be_an Array
#      expect(emoji.first).to be_a Hash
#    end
#  end
#
#  describe '#single_emoji' do
#    before do
#      stub_get("#{api_url}/emoji/emoji.json")
#        .to_return(
#                    body: fixture('single_emoji.json'),
#                    headers: { content_type: 'application/json' }
#                  )
#    end
#
#    it 'requests the correct resource' do
#      subject.single_emoji
#      expect(a_get("#{api_url}/emoji/emoji.json")).to have_been_made
#    end
#
#    it 'returns the requested emoji' do
#      emoji = subject.single_emoji
#      expect(emoji).to be_a Hash
#    end
#  end
#
#  describe '#single_emoji_detailed' do
#    before do
#      stub_get("#{api_url}/emoji/1/detailed.json")
#        .to_return(
#                    body: fixture('single_emoji_detailed.json'),
#                    headers: { content_type: 'application/json' }
#                  )
#    end
#
#    it 'requests the correct resource' do
#      subject.single_emoji_detailed
#      expect(a_get("#{api_url}/emoji/1/detailed.json")).to have_been_made
#    end
#
#    it 'returns the requested emoji' do
#      emoji = subject.single_emoji_detailed
#      expect(emoji).to be_a Hash
#    end
#  end
#
#end
