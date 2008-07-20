#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'ronin/rpc/exceptions/not_implemented'
require 'ronin/rpc/exceptions/unknown_service'

module Ronin
  module RPC
    class Client

      # The Service to interface with
      attr_reader :service

      def initialize(service)
        @service = service
      end

      def call(func,*args)
        return_value(send_call(create_call(func,*args)))
      end

      protected

      def create_call(func,*args)
        raise(NotImplemented,"the \"create_call\" method is not implemented in #{self.class}",caller)
      end

      def send_call(func,*args)
        raise(NotImplemented,"the \"send_call\" method is not implemented in #{self.class}",caller)
      end

      def return_value(response)
        raise(NotImplemented,"the \"return_value\" method is not implemented in #{self.class}",caller)
      end

      def method_missing(sym,*args)
        call(func,*args)
      end

    end
  end
end