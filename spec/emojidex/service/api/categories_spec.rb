#require 'spec_helper'
#
#describe Emojidex::API::Categories do
#
#  subject { Emojidex::Client.new(host: 'http://localhost') }
#  let!(:api_url) { 'http://localhost/api/v1' }
#
#  describe '#categories' do
#    before do
#      stub_get("#{api_url}/categories.json")
#        .to_return(
#                    body: fixture('categories.json'),
#                    headers: { content_type: 'application/json' }
#                  )
#    end
#
#    it 'requests the correct resource' do
#      subject.categories
#      expect(a_get("#{api_url}/categories.json")).to have_been_made
#    end
#
#    it 'returns the requested categories' do
#      categories = subject.categories
#      expect(categories).to be_an Array
#      expect(categories.first).to be_a Hash
#    end
#  end
#
#  describe '#category' do
#    before do
#      stub_get("#{api_url}/categories/category.json")
#        .to_return(
#                    body: fixture('category.json'),
#                    headers: { content_type: 'application/json' }
#                  )
#    end
#
#    it 'requests the correct resource' do
#      subject.category
#      expect(a_get("#{api_url}/categories/category.json")).to have_been_made
#    end
#
#    it 'returns the requested category' do
#      category = subject.category
#      expect(category).to be_a Hash
#    end
#  end
#
#end
