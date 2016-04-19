require 'kumamoto/version'
require 'kumamoto/configuration'

module Kumamoto
  HTTP_USER_AGENT = 'Kumamoto data Bot (see: https://github.com/kengos/kumamoto)'.freeze

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
    alias :config :configuration
  end

  autoload :FileBuilder, 'kumamoto/file_builder'
  autoload :CapybaraClient, 'kumamoto/capybara_client'
  autoload :Earthquake, 'kumamoto/earthquake'
end
