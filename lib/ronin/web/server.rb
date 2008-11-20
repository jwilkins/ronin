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

require 'rack'

module Ronin
  module Web
    class Server < Rack::Builder

      # Built-in HTTP Content-Types
      CONTENT_TYPES = {
        'text/html' => ['html', 'htm', 'xhtml'],
        'text/css' => ['css'],
        'image/gif' => ['gif'],
        'image/jpeg' => ['jpeg', 'jpg'],
        'image/png' => ['png'],
        'image/x-icon' => ['ico'],
        'text/javascript' => ['js'],
        'text/xml' => ['xml'],
        'application/rss+xml' => ['rss'],
        'application/rdf+xml' => ['rdf'],
        'application/pdf' => ['pdf'],
        'application/doc' => ['doc'],
        'application/zip' => ['zip'],
        'text/plain' => ['txt']
      }

      #
      # Creates a new Web Server using the given configuration _block_.
      #
      def initialize(&block)
        super { run(method(:route)) }

        instance_eval(&block) if block
      end

      def Server.default_host
        @@default_host ||= 'localhost'
      end

      def Server.default_host=(host)
        @@default_host = host
      end

      def Server.default_port
        @@default_port ||= 8080
      end

      def Server.default_port=(port)
        @@default_port = port
      end

      def self.start(&block)
        self.new(&block).start
      end

      #
      # Binds the contents of the specified _file_ to the specified URL
      # _path_, using the given _options_.
      #
      #   srv.bind '/robots.txt', '/path/to/my_robots.txt'
      #
      def bind(path,file,options={})
        content_type = (options[:content_type] || content_type_for(file))

        map(path) do |env|
          return_file(file)
        end
      end

      #
      # Mounts the contents of the specified _directory_ to the given
      # prefix _path_.
      #
      #   srv.mount '/download/', '/tmp/files/'
      #
      def mount(path,dir)
        map(path) do |env|
          sub_path = File.expand_path(env['HTTP_PATH']).sub(path,'')
          absolute_path = File.join(dir,sub_path)

          if File.file?(absolute_path)
            return_file(absolute_path)
          else
            not_found(env)
          end
        end
      end

      #
      # Starts the server.
      #
      def start(options={})
        host = (options[:host] || Server.default_host)
        port = (options[:port] || Server.default_port)

        Rack::Handler::WEBrick.run(self, :Host => host, :Port => port)
        return self
      end

      protected

      #
      # Returns the HTTP Content-Type for the specified _file_.
      #
      #   srv.content_type_for('file.html')
      #   # => "text/html"
      #
      def content_type_for(file)
        ext = File.extname(file)

        CONTENT_TYPES.each do |content_type,exts|
          return content_type if exts.include?(ext)
        end

        return 'application/x-unknown-content-type'
      end

      #
      # Returns a HTTP 200 response with the contents of the specified
      # _file_.
      #
      def return_file(file)
        [200, {'Content-Type' => content_type_for(file)}, File.read(file)]
      end

      #
      # Returns the HTTP 404 Not Found message for the requested path.
      #
      def not_found(env)
        path = env['HTTP_PATH']

        [404, {'Content-Type' => 'text/html'}, %{
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
  <head>
    <title>404 Not Found</title>
  <body>
    <h1>Not Found</h1>
    <p>The requested URL #{path} was not found on this server.</p>
    <hr>
  </body>
</html>}]
      end

      #
      # The method which receives all requests.
      #
      def route(env)
        not_found(env)
      end

    end
  end
end