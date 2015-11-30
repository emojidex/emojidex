require 'spec_helper'
require 'emojidex/service/user'


describe Emojidex::Service::User do
  describe 'initialize' do
    it 'sets defaults' do
      user = Emojidex::Service::User.new
      expect(user.username).to eq ''
      expect(user.pro).to eq false
      expect(user.premium).to eq false
      expect(user.pro_exp).to eq nil
      expect(user.premium_exp).to eq nil
    end

    it 'has a set of auth status codes which define if a user is authorized' do
      expect(Emojidex::Service::User.auth_status_codes.include? :verified).to be true
      expect(Emojidex::Service::User.auth_status_codes.include? :unverified).to be true
      expect(Emojidex::Service::User.auth_status_codes[:verified]).to be true
      expect(Emojidex::Service::User.auth_status_codes[:unverified]).to be false
    end

    it 'defaults to an unauthroized state' do
      user = Emojidex::Service::User.new
      expect(user.authorized?).to be false
    end

    it 'fails authorization with a bad token, passes with a good token' do
      user = Emojidex::Service::User.new
      expect(user.authorize('test', '12345')).to be false
      expect(user.status).to eq :unverified

      expect(user.authorize('test',
                            '1798909355d57c9a93e3b82d275594e7c7c000db05021138')).to be true
      expect(user.status).to eq :verified
    end
  end
end
