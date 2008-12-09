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

module Ronin
  module Hexdump
    def hexdump
      index = 0
      offset = 0
      hex_segment = nil
      print_segment = nil

      segment = lambda {
        STDOUT.printf(
          "%.8x  %s  |%s|\n",
          index,
          hex_segment.join(' ').ljust(47),
          print_segment
        )
      }

      each_byte do |b|
        if offset == 0
          hex_segment = []
          print_segment = [' '] * 16
        end

        hex_segment << ("%.2x" % b)

        print_segment[offset] = case b
                                when (0x20..0x7e)
                                  b.chr
                                else
                                  '.'
                                end

        offset += 1

        if (offset >= 16)
          segment.call

          offset = 0
          index += 16
        end
      end

      unless offset == 0
        segment.call
      end

      return nil
    end
  end
end