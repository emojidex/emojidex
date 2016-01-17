require 'spec_helper'
require 'emojidex/service/user'

describe Emojidex::Service::User do
  it 'has a set of auth status codes which define if a user is authorized' do
    expect(Emojidex::Service::User.auth_status_codes.include? :verified).to be true
    expect(Emojidex::Service::User.auth_status_codes.include? :unverified).to be true
    expect(Emojidex::Service::User.auth_status_codes[:verified]).to be true
    expect(Emojidex::Service::User.auth_status_codes[:unverified]).to be false
  end

  describe 'initialize' do
    it 'sets defaults' do
      user = Emojidex::Service::User.new
      expect(user.username).to eq ''
      expect(user.pro).to eq false
      expect(user.premium).to eq false
      expect(user.pro_exp).to eq nil
      expect(user.premium_exp).to eq nil
    end

    it 'defaults to an unauthroized state' do
      user = Emojidex::Service::User.new
      expect(user.authorized?).to be false
    end
  end

  describe 'authorize' do
    it 'fails authorization with a bad token' do
      user = Emojidex::Service::User.new
      expect(user.authorize('test', '12345')).to be false
      expect(user.status).to eq :unverified
    end

    it 'authorizes with a good token' do
      user = Emojidex::Service::User.new
      expect(user.authorize('test',
                            '1798909355d57c9a93e3b82d275594e7c7c000db05021138')).to be true
      expect(user.status).to eq :verified
    end

    it 'fails to sync history when unauthorized' do
      user = Emojidex::Service::User.new
      expect(user.sync_history).to be false
      expect(user.history.class == Array).to be true
      expect(user.history.size).to eq 0
    end

    it 'syncs history when authorized' do
      user = Emojidex::Service::User.new
      user.authorize('test', '1798909355d57c9a93e3b82d275594e7c7c000db05021138')
      expect(user.sync_history(10)).to be true
      puts "HISTORY SIZE #{user.history.size}"
      expect(user.history.size == 10).to be true
      expect(user.sync_history(20)).to be true
      expect(user.history.size == 20).to be true
    end

    it 'adds to history' do
      user = Emojidex::Service::User.new
      expect(user.add_history('two_hearts')).to be false
      user.authorize('test', '1798909355d57c9a93e3b82d275594e7c7c000db05021138')
      user.sync_history
      expect(user.add_history('two_hearts')).to be true
      expect(user.history[0].emoji_code).to eq 'two_hearts'
      expect(user.add_history('jijijijijiijijijijijijijijijijijijiji')).to be false
    end

    it 'fails to sync favorites when unauthorized' do
      user = Emojidex::Service::User.new
      expect(user.sync_favorites).to be false
    end

    it 'syncs favorites when authorized' do
      user = Emojidex::Service::User.new
      user.authorize('test', '1798909355d57c9a93e3b82d275594e7c7c000db05021138')
      expect(user.sync_favorites).to be true
      expect(user.favorites.emoji.length > 0).to be true
    end

    it 'refuses to add a favorite when not authorized' do
      user = Emojidex::Service::User.new
      expect(user.add_favorite('combat knife')).to be false
    end

    it 'adds a favorite when authorized' do
      user = Emojidex::Service::User.new
      user.authorize('test', '1798909355d57c9a93e3b82d275594e7c7c000db05021138')
      user.remove_favorite('combat_knife')
      expect(user.favorites.emoji.include? :combat_knife).to be false
      expect(user.add_favorite('combat_knife')).to be true
      expect(user.favorites.emoji.include? :combat_knife).to be true
    end

    it 'refuses to remove a favorite when not authorized' do
      user = Emojidex::Service::User.new
      expect(user.remove_favorite('combat_knife')).to be false
    end

    it 'removes a favorite when authorized' do
      user = Emojidex::Service::User.new
      user.authorize('test', '1798909355d57c9a93e3b82d275594e7c7c000db05021138')
      user.add_favorite('combat_knife')
      expect(user.remove_favorite('combat_knife')).to be true
      expect(user.favorites.emoji.include? :combat_knife).to be false
    end

    it 'saves user data' do
      clear_tmp_cache
      user = Emojidex::Service::User.new
      user.authorize('test', '1798909355d57c9a93e3b82d275594e7c7c000db05021138')
      user.save(tmp_cache_path)
      expect(File.exist? "#{tmp_cache_path}/user.json").to be true
      expect(File.exist? "#{tmp_cache_path}/history.json").to be true
      expect(File.exist? "#{tmp_cache_path}/favorites.json").to be true
    end

    it 'loads user data' do
      clear_tmp_cache
      user = Emojidex::Service::User.new
      user.authorize('test', '1798909355d57c9a93e3b82d275594e7c7c000db05021138')
      user.sync_favorites
      user.sync_history
      user.add_favorite('忍者') # just in case
      user.save(tmp_cache_path)

      # without syncing
      user = Emojidex::Service::User.new
      user.load(tmp_cache_path)
      expect(user.username).to eq 'test'
      expect(user.authorized?).to be true
      expect(user.favorites.emoji.count > 0).to be true
      expect(user.history.length > 0).to be true

      # with syncing
      user = Emojidex::Service::User.new
      user.load(tmp_cache_path, false)
      expect(user.username).to eq 'test'
      expect(user.authorized?).to be false
      expect(user.status).to be :loaded
      expect(user.favorites.emoji.count > 0).to be true
      expect(user.history.length > 0).to be true
    end

    it 'auto loads user data when a cache path is specified' do
      clear_tmp_cache
      user = Emojidex::Service::User.new(cache_path: tmp_cache_path)
      expect(user.cache_path).to eq tmp_cache_path
      expect(user.username).to eq ''
      expect(user.auth_token).to eq ''
      expect(user.status).to_not be :loaded
      user.authorize('test', '1798909355d57c9a93e3b82d275594e7c7c000db05021138')
      user.save(tmp_cache_path)
    end
  end
end
