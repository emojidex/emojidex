require_relative '../../emojidex'
require_relative 'error'
require_relative 'transactor'
require_relative 'collection'

module Emojidex
  module Service
    # User auth and user details
    class User
      attr_reader :username, :auth_token, :premium, :pro, :premium_exp, :pro_exp, :status
      attr_accessor :favorites, :history

      @@auth_status_codes = { none: false, failure: false, unverified: false, verified: true }
      def self.auth_status_codes
        @@auth_status_codes
      end

      def initialize(opts = {})
        clear_auth_data
        @status = :none
        @history = []
        @favorites = Emojidex::Data::Collection.new
      end

      def login(user, password)
        begin
          auth_response = Transactor.get('users/authenticate',
                            { user: user, password: password })
        rescue Error::Unauthorized
          @status = :unverified
          return false
        end
        _process_auth_response(auth_response)
      end

      def authorize(username, auth_token)
        begin
          auth_response = Transactor.get('users/authenticate',
                            { username: username, token: auth_token })
        rescue Error::Unauthorized
          @status = :unverified
          return false
        end

        _process_auth_response(auth_response)
      end

      def authorized?
        @@auth_status_codes[@status]
      end

      def sync_favorites(limit = Emojidex::Defaults.limit, detailed = true)
        return false unless authorized?

        begin
          res = Emojidex::Service::Collection.new(
            { endpoint: 'users/favorites', limit: limit, detailed: detailed,
             username: @username, auth_token: @auth_token })
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
                  { username: @username, auth_token: @auth_token,
                   emoji_code: Emojidex.escape_code(code) })
        rescue Error::Unauthorized
          return false
        rescue Error::UnprocessableEntity => e
          # TODO: API is currently returning this both when emoji already registered
          # and when code is invalid. When already registerd it will return 202 on
          # next update
          return true if e.message == 'emoji already in user favorites'
          return false
        end
        return true
      end

      def remove_favorite(code)
        return false unless authorized?

        begin
          res = Transactor.delete('users/favorites',
                  { username: @username, auth_token: @auth_token,
                   emoji_code: Emojidex.escape_code(code) })
        rescue Error::Unauthorized
          return false
        rescue Error::UnprocessableEntity => e
          # TODO: API is currently returning this both when emoji already registered
          # and when code is invalid. When already registerd it will return 200 on
          # next update
          return true if e.message == 'emoji not in user favorites'
          return false
        end
        true
      end

      def sync_history(limit = Emojidex::Defaults.limit, page = 1)
        return false unless authorized?

        @history = Transactor.get('users/history',
                    { limit: limit, page: page, username: @username, auth_token: @auth_token })
        # TODO: this is a temporary implementation of history. It will be revised after an
        # API update.
        true
      end

      def add_history(code)
      end

      def clear_auth_data()
        @username = @auth_token = ''
        @pro = false
        @premium = false
        @pro_exp = nil
        @premium_exp = nil
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
    end
  end
end
