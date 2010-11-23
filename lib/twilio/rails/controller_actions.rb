module Twilio
  module Rails
    class InvalidRequest < StandardError; end;
    module ControllerActions
      def self.included(base)
        base.send :include, InstanceMethods        
        base.send :before_filter, :check_twilio_signature
      end
      
      module InstanceMethods
        
        private
        
        def check_twilio_signature
          r = Twilio::Rails::Request.new(
            :signature => twilio_signature, :url => request.url
          )
          r.raw_post = request.raw_post if request.headers["REQUEST_METHOD"] == "POST"
          return true if r.valid?
          raise Twilio::Rails::InvalidRequest, "This request did not match the signature '#{twilio_signature}'"
        end
        
        def twilio_signature
          request.headers["HTTP_X_TWILIO_SIGNATURE"]
        end
        
      end
    end
  end
end
