require_relative '../../emojidex'
require_relative 'error'
require_relative 'transactor'
require_relative 'collection'
require_relative './user/history_item'

module Emojidex
  module Service
    # User auth and user details
    class User
      attr_reader :username, :auth_token, :premium, :pro, :premium_exp, :pro_exp, :status
      attr_accessor :favorites, :history, :history_page, :cache_path

      @@auth_status_codes = { none: false, failure: false,
                              unverified: false, verified: true,
                              loaded: false }
      def self.auth_status_codes
        @@auth_status_codes
      end

      def initialize(opts = {})
        clear_auth_data
        @status = :none
        @history = []
        @history_page = 0
        @favorites = Emojidex::Data::Collection.new
        if opts.key?(:cache_path)
          load(opts[:cache_path])
        elsif opts[:load_cache] == true
          load
        end
      end

      def login(user, password, sync_on_login = true)
        begin
          auth_response = Transactor.get('users/authenticate',
                                         user: user, password: password)
        rescue Error::Unauthorized
          @status = :unverified
          return false
        end

        return false unless _process_auth_response(auth_response)
        if sync_on_login
          sync_favorites
          sync_history
        end
        true
      end

      def authorize(username, auth_token, sync_on_auth = true)
        begin
          auth_response = Transactor.get('users/authenticate',
                                         username: username, token: auth_token)
        rescue Error::Unauthorized
          @status = :unverified
          return false
        end

        return false unless _process_auth_response(auth_response)
        if sync_on_auth
          sync_favorites
          sync_history
        end
        true
      end

      def authorized?
        @@auth_status_codes[@status]
      end

      def sync_favorites(limit = Emojidex::Defaults.limit, detailed = true)
        return false unless authorized?

        begin
          res = Emojidex::Service::Collection.new(
            endpoint: 'users/favorites', limit: limit, detailed: detailed,
            username: @username, auth_token: @auth_token)
        rescue Error::Unauthorized
          return false
        end

        @favorites = res
        true
      end

      def add_favorite(code)
        return false unless authorized?

        begin
          res = Transactor.post('users/favorites',
                                username: @username, auth_token: @auth_token,
                                emoji_code: Emojidex.escape_code(code))
        rescue Error::Unauthorized
          return false
        end
        return false if res.include?(:status) && res[:status] == 'emoji already in user favorites'
        @favorites.add_emoji([res])
        true
      end

      def remove_favorite(code)
        return false unless authorized?

        begin
          res = Transactor.delete('users/favorites',
                                  username: @username, auth_token: @auth_token,
                                  emoji_code: Emojidex.escape_code(code))
        rescue Error::Unauthorized
          return false
        end
        return false if res.include?(:status) && res[:status] == 'emoji not in user favorites'
        @favorites.remove_emoji(code.to_sym)
        true
      end

      def sync_history(limit = Emojidex::Defaults.limit, page = 0)
        return false unless authorized?

        page = @history_page + 1 if page == 0

        begin
          result = Transactor.get('users/history',
                                      limit: limit, page: page,
                                      username: @username, auth_token: @auth_token)
        rescue
          return false
        end

        return false unless (result.key?(:history) && result.key?(:meta))
        @history_page = result[:meta][:page]
        _merge_history(result[:history])
        true
      end

      def add_history(code)
        return false unless authorized?

        begin
          result = Transactor.post('users/history',
                                   username: @username, auth_token: @auth_token,
                                   emoji_code: Emojidex.escape_code(code))
        rescue
          return false
        end

        _push_and_dedupe_history(result)
        true
      end

      def clear_auth_data()
        @username = @auth_token = ''
        @pro = false
        @premium = false
        @pro_exp = nil
        @premium_exp = nil
      end

      def sync
        authorize(@username, @auth_token) && sync_favorites && sync_history
      end

      def save(path = nil)
        _set_cache_path(path)
        _save_user
        _save_favorites
        _save_history
      end

      def load(path = nil, auto_sync = true)
        _set_cache_path(path)
        _load_user
        _load_favorites
        _load_history
        sync if auto_sync
      end

      private

      def _process_auth_response(auth_response)
        if auth_response[:auth_status] == 'verified'
          _set_verified_data(auth_response)
          return true
        elsif auth_response[:auth_status] == 'unverified'
          @status = :unverified
        else
          @status = :failure
        end
        clear_auth_data
        false
      end

      def _set_verified_data(auth_response)
        @status = :verified
        @username = auth_response[:auth_user]
        @auth_token = auth_response[:auth_token]
        @pro = auth_response[:pro]
        @premium = auth_response[:premium]
        @pro_exp = auth_response[:pro_exp]
        @premium_exp = auth_response[:premium_exp]
      end

      def _set_cache_path(path)
        @cache_path ||= File.expand_path(path || Emojidex::Defaults.system_cache_path)
        FileUtils.mkdir_p(@cache_path)
        @cache_path
      end

      def _save_user
        user_info = { username: username, auth_token: auth_token,
                      premium: premium, pro: pro,
                      premium_exp: premium_exp, pro_exp: pro_exp
                    }
        File.open("#{@cache_path}/user.json", 'w') { |f| f.write user_info.to_json }
      end

      def _save_favorites
        File.open("#{@cache_path}/favorites.json", 'w') do |f|
          f.write @favorites.emoji.values.to_json
        end
      end

      def _save_history
        File.open("#{@cache_path}/history.json", 'w') { |f| f.write @history.to_json }
      end

      def _load_user
        _save_user unless File.exist? "#{@cache_path}/user.json"
        json = IO.read("#{@cache_path}/user.json")
        user_info = JSON.parse(json, symbolize_names: true)
        @username = user_info[:username]
        @auth_token = user_info[:auth_token]
        @premium = user_info[:premium]
        @pro = user_info[:pro]
        @premium_exp = user_info[:premium_exp]
        @pro_exp = user_info[:pro_exp]
        @status = :loaded
      end

      def _load_favorites
        _save_favorites unless File.exist? "#{@cache_path}/favorites.json"
        json = IO.read("#{@cache_path}/favorites.json")
        @favorites = Emojidex::Service::Collection.new(
          emoji: JSON.parse(json, symbolize_names: true),
          auto_init: false)
      end

      def _load_history
        _save_history unless File.exist? "#{@cache_path}/history.json"
        json = IO.read("#{@cache_path}/history.json")
        @history = JSON.parse json
      end

      def _merge_history(history_delta = [])
        history_delta.each do |item|
          _push_and_dedupe_history(item)
        end
        _sort_history
      end

      def _push_and_dedupe_history(item)
        i = 0
        while i < (@history.size - 1) do
          if @history[i].emoji_code == item[:emoji_code]
            @history.delete_at i
            break
          end
          i += 1
        end
        @history.unshift Emojidex::Service::HistoryItem.new(item[:emoji_code],
                                                            item[:times_used], item[:last_used])
      end

      def _sort_history
        # TODO implement sort by date
      end
    end
  end
end
