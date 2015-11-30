require_relative '../../emojidex'
require_relative 'transactor'

module Emojidex
  module Service
    # User auth and user details
    class User
      attr_reader :username, :token, :premium, :pro, :premium_exp, :pro_exp, :status
      attr_accessor :favorites, :history

      @@auth_status_codes = {none: false, failure: false, unverified: false, verified: true}
      def self.auth_status_codes
        @@auth_status_codes
      end

      def initialize(opts = {})
        @username = @token = ''
        @premium = false
        @pro = false
        @premium_exp = nil
        @pro_exp = nil
        @status = :none
      end

      def login(user, password)
      end

      def authorize(username, token)
        auth_response = Emojidex::Service::Transactor.get('users/authenticate',
                                                          {username: username, token: token})
        if auth_response['auth_status'] == 'verified'
          @status = :verified
          @username = auth_response[:auth_user]
          @token = auth_response[:auth_token]
          @pro = auth_response[:pro]
          @premium = auth_response[:premium]
          @pro_exp = auth_response[:pro_exp]
          @premium_exp = auth_response[:premium_exp]
          return true
        elsif auth_response['auth_status'] == 'unverified'
          @status = :unverified
        else
          @status = :failure
        end
        @username = @token = ''
        @pro = false
        @premium = false
        @pro_exp = nil
        @premium_exp = nil
        false
      end

      def authorized?
        @@auth_status_codes[@status]
      end

      def sync_favorites()
        #Transactor.get(
      end
    end
  end
end
