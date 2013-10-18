require "forwardable"
require "stacker_bee/configuration"
require "stacker_bee/api"
require "stacker_bee/connection"
require "stacker_bee/request"
require "stacker_bee/response"

module StackerBee
  class Client
    DEFAULT_API_PATH = File.join(File.dirname(__FILE__), '../../config/4.2.json')

    extend Forwardable
    def_delegators :configuration, :url, :url=, :api_key, :api_key=, :secret_key, :secret_key=

    class << self

      def reset!
        @api, @api_path, @default_config = nil
      end

      def default_config
        @default_config ||= {}
      end

      def configuration=(config_hash)
        self.default_config.merge!(config_hash)
      end

      def api_path
        @api_path ||= DEFAULT_API_PATH
      end

      def api_path=(new_api_path)
        return @api_path if @api_path == new_api_path
        @api = nil
        @api_path = new_api_path
      end

      def api
        @api ||= API.new(api_path: api_path)
      end
    end

    def initialize(config = {})
      self.configuration = config
    end

    def configuration=(config)
      @configuration = configuration_with_defaults(config)
    end

    def configuration
      @configuration ||= configuration_with_defaults
    end

    def request(endpoint, params = {})
      request      = Request.new(endpoint, self.api_key, params) 
      raw_response = self.connection.get(request)
      Response.new(raw_response)
    end

    def method_missing(name, *args, &block)
      api = self.class.api.endpoints[name.to_s]
      super unless api
      self.request(name, *args)
    end

    def respond_to?(name, include_private = false)
      if self.class.api.endpoints.keys.include?(name.to_s)
        true
      else
        super
      end
    end

    # def list_virtual_machines(options = {})
    #    self.request(:list_virtual_machines, options)["listvirtualmachinesresponse"]["virtualmachine"]
    # end

    protected

    def connection
      @connection ||= Connection.new(self.configuration)
    end

    def configuration_with_defaults(config = {})
      config_hash = self.class.default_config.merge(config)
      Configuration.new(config_hash)
    end
  end
end
