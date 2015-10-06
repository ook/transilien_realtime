require 'http'
require 'nokogiri'
require 'oj'

module TransilienRealtime
  class Base
    DOCUMENTATION_VERSION = '0.2'
    API_VERSION = '1.0'
    
    API_TARGETS = {
      production: 'http://api.transilien.com/',
      staging: 'http://85.233.209.222:1399/'
    }

    ACCEPT_STRINGS = {
        '1.0' => 'application/vnd.sncf.transilien.od.depart+xml;vers=1.0'
    }

    def initialize(user: ENV['RTT_API_USER'], pwd: ENV['RTT_API_PWD'], target: :production)
      @user = user
      @pwd = pwd

      @target = target
    end

    def next(from:, to: nil)
      raise ArgumentError, 'from param is mandatory' unless from
      fetch(build_request(from, to))
      self
    end

    def xml_document
      return nil unless @content
      Nokogiri::XML(@content)
    end

    def xml
      @content
    end

    def json
      return nil unless trains
      "[#{trains.map(&:to_json).join(',')}]"
    end

    def response; @response; end
    def body; @body; end
    def content; @content; end

    def trains
      @trains ||= begin
        return nil unless xml_document
        trains = []
        xml_document.xpath('//train').each do |train_node|
          begin
            trains << Train.from_xml(train_node)
          rescue Exception => e
            $stderr << "FAILURE! WAS READING #{train_node.to_s.inspect}"
            raise e
          end
        end
        trains.freeze
      end 
    end

    protected

    def build_request(from, to)
      request = API_TARGETS[@target]
      request += "gare/#{from}/depart/"
      request += "#{to}/" if to
      request
    end

    def fetch(request)
      @trains = nil # destroy cache
      @response = HTTP.basic_auth(user: @user, pass: @pwd).headers(accept: ACCEPT_STRINGS[API_VERSION]).get(request)#.body
      @body = @response.body
      @content = @body.readpartial
    end

  end
end
