require 'metasploit/framework/tcp/client'
require 'metasploit/framework/afp/client'
require 'metasploit/framework/login_scanner/base'
require 'metasploit/framework/login_scanner/rex_socket'

module Metasploit
  module Framework
    module LoginScanner

      # This is the LoginScanner class for dealing with Apple Filing
      # Protocol.
      class AFP
        include Metasploit::Framework::LoginScanner::Base
        include Metasploit::Framework::LoginScanner::RexSocket
        include Metasploit::Framework::Tcp::Client
        include Metasploit::Framework::AFP::Client

        # @!attribute login_timeout
        #   @return [Integer] Number of seconds to wait before giving up
        attr_accessor :login_timeout

        def attempt_login(credential)
          begin
            connect
          rescue Rex::ConnectionError, EOFError, Timeout::Error
            status = :connection_error
          else
            success = login(credential.public, credential.private)
            status = (success == true) ? :success : :failed
          end

          Result.new(credential: credential, status: status)
        end

        def set_sane_defaults
          self.port          = 548 if self.port.nil?
          self.max_send_size = 0 if self.max_send_size.nil?
          self.send_delay    = 0 if self.send_delay.nil?
        end
      end
    end
  end
end