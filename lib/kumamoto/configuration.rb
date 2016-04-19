module Kumamoto
  class Configuration
    attr_accessor :root_path
    attr_accessor :resource_path

    def initialize
      @root_path = Pathname.new(File.expand_path('../../', __dir__))
      @resource_path = @root_path.join('resources')
    end
  end
end