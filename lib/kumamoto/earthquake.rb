require 'active_support'
require 'active_support/core_ext'
require 'active_model'

module Kumamoto
  module Earthquake
    autoload :Client, 'kumamoto/earthquake/client'
    module Epicenter
      autoload :Model, 'kumamoto/earthquake/epicenter/model'
      autoload :Parser, 'kumamoto/earthquake/epicenter/parser'
    end
  end
end