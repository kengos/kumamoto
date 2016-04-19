require 'capybara'
require 'capybara/poltergeist'

module Kumamoto
  class CapybaraClient
    Capybara.run_server = false
    Capybara.register_driver :poltergeist do |app|
      options = {
        js_errors: false, timeout: 240, headers: { 'HTTP_USER_AGENT' => Kumamoto::HTTP_USER_AGENT }
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    def page
      @page ||= ::Capybara::Session.new(:poltergeist)
    end

    def scrape &block
      yield self
    end

    def wait_for(selector)
      Timeout.timeout(60) do
        loop until page.has_css?(selector)
      end
    end

    def self.scrape(&block)
      new.scrape(&block)
    end
  end
end