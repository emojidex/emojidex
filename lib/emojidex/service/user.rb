module Emojidex::Service
  # User auth and user details
  class User
    attr_reader :username, :token, :premium, :pro, :premium_exp, :pro_exp

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
  end
end
