#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#

require 'ronin/net/udp'
require 'ronin/parameters'
require 'ronin/parameters/exceptions/paramnotfound'

module Ronin
  module Sessions
    module UDP
      include Net::UDP
      include Parameters

      def self.included(base)
        base.module_eval do
          parameter :lhost, :description => 'local host'
          parameter :lport, :description => 'local port'

          parameter :rhost, :description => 'remote host'
          parameter :rport, :description => 'remote port'
        end
      end

      def self.extended(obj)
        obj.instance_eval do
          parameter :lhost, :description => 'local host'
          parameter :lport, :description => 'local port'

          parameter :rhost, :description => 'remote host'
          parameter :rport, :description => 'remote port'
        end
      end

      protected

      def udp_connect(&block)
        unless @rhost
          raise(ParamNotFound,"Missing '#{describe_param(:rhost)}' parameter",caller)
        end

        unless @rport
          raise(ParamNotFound,"Missing '#{describe_param(:rport)}' parameter",caller)
        end

        return UDP.connect(@rhost,@rport,@lhost,@lport,&block)
      end

      def udp_connect_and_recv(&block)
        unless @rhost
          raise(ParamNotFound,"Missing '#{describe_param(:rhost)}' parameter",caller)
        end

        unless @rport
          raise(ParamNotFound,"Missing '#{describe_param(:rport)}' parameter",caller)
        end

        return UDP.connect_and_recv(@rhost,@rport,@lhost,@lport,&block)
      end

      def udp_connect_and_send(data,&block)
        unless @rhost
          raise(ParamNotFound,"Missing '#{describe_param(:rhost)}' parameter",caller)
        end

        unless @rport
          raise(ParamNotFound,"Missing '#{describe_param(:rport)}' parameter",caller)
        end

        return UDP.connect_and_send(data,@rhost,@rport,@lhost,@lport,&block)
      end

      def udp_listen(&block)
        # TODO: implement some sort of basic udp server
      end
    end
  end
end