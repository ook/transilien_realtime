require "http"

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
      request = API_TARGETS[@target]
      request += "gare/#{from}/depart/"
      request += "#{to}/" if to
      @response = HTTP.basic_auth(user: @user, pass: @pwd).headers(accept: ACCEPT_STRINGS[API_VERSION]).get(request)#.body
      @body = @response.body
      @content = @body.readpartial
      self
    end

    def response; @response; end
    def body; @body; end
    def content; @content; end

  end
end
