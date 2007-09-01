#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'ronin/parameters'

require 'socket'

module Ronin
  module Proto
    module UDP
      include Parameters

      def self.included(klass)
        klass.parameter :lhost, :desc => 'local host'
        klass.parameter :lport, :desc => 'local port'

        klass.parameter :rhost, :desc => 'remote host'
        klass.parameter :rport, :desc => 'remote port'
      end

      def self.extended(obj)
        obj.parameter :lhost, :desc => 'local host'
        obj.parameter :lport, :desc => 'local port'

        obj.parameter :rhost, :desc => 'remote host'
        obj.parameter :rport, :desc => 'remote port'
      end

      protected

      def udp_connect(&block)
        unless rhost
          raise(MissingParam,"Missing '#{describe_param(:rhost)}' parameter",caller)
        end

        unless rport
          raise(MissingParam,"Missing '#{describe_param(:rport)}' parameter",caller)
        end

        return UDPSocket.new(rhost,rport,&block)
      end

      def udp_listen(&block)
        # TODO: implement some sort of basic udp server
      end
    end
  end
end