#require 'spec_helper'
#
#describe Emojidex::Client do
#
#  describe 'initialize' do
#    it 'sets default host' do
#      client = Emojidex::Client.new
#      expect(client.host).to eq 'https://www.emojidex.com'
#    end
#
#    it 'sets custom host' do
#      client = Emojidex::Client.new(host: 'example.com')
#      expect(client.host).to eq 'example.com'
#    end
#  end
#
#  describe 'user_agent' do
#    it 'sets user_agent' do
#      client = Emojidex::Client.new
#      expect(client.user_agent).to eq 'emojidexRuby'
#    end
#  end
#
#end
