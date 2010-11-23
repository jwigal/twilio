require 'twilio/rails/request'
require 'twilio/rails/controller_actions'
module Twilio
  module Rails
    
    class << self      
      attr_reader :sid, :token
    end
    
    def self.connect(account_sid, auth_token)
      @sid, @token = account_sid, auth_token
      ::Twilio.connect(account_sid, auth_token)
    end

  end
end
