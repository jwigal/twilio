module Twilio
  module Rails
    class Request
      attr_accessor :signature, :url, :raw_post

      def initialize(p={})
        p.each {|k,v| self.send("#{k.to_s}=".to_sym, v) if self.respond_to?("#{k.to_s}=".to_sym)}
      end
      
      def token
        ::Twilio::Rails.token if defined?(::Twilio::Rails.token)
      end
      
      def sorted_post_params
        return "" unless @raw_post
        ordered_keys = @raw_post.split('&').collect do |k_v|
          [CGI::unescape(k_v.split('=')[0].to_s),CGI::unescape(k_v.split('=')[1].to_s)]
        end
        ordered_keys.sort{|a,b| a[0] <=> b[0]}.flatten.join("")
      end
      
      def valid?
        data = @url + sorted_post_params
        digest = OpenSSL::Digest::Digest.new('sha1')
        expected = Base64.encode64(OpenSSL::HMAC.digest(digest, token, data)).strip
        return expected == @signature
      end
      
    end
  end
end
