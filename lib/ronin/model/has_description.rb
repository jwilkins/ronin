#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/model'

module Ronin
  module Model
    module HasDescription
      include DataMapper::Types

      def self.included(base)
        base.module_eval do
          include Ronin::Model

          # The description of the model
          property :description, Text

          #
          # Finds models with descriptions similar to the specified
          # _description_.
          #
          def self.describing(description)
            self.all(:description.like => "%#{description}%")
          end
        end
      end
    end
  end
end
