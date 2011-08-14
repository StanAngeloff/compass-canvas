require 'canvas/functions/canvas'
require 'canvas/functions/context'
require 'canvas/functions/path'
require 'canvas/functions/pattern'

module Compass::Canvas
  # The +Functions+ module aggregates all exported functions.
  #
  # @see Compass::Canvas::Functions::Canvas
  # @see Compass::Canvas::Functions::Context
  # @see Compass::Canvas::Functions::Path
  # @see Compass::Canvas::Functions::Pattern
  module Functions
    include Canvas
    include Context
    include Path
    include Pattern

    def self.unpack(value)
      if value.is_a?(Compass::Canvas::Backend::Interface::Base)
        value
      elsif value.is_a?(Sass::Script::Literal)
        Compass::Canvas::Functions.unpack(value.value)
      elsif value.is_a?(Array)
        value.map { |child| Compass::Canvas::Functions.unpack(child) }
      else
        value
      end
    end
  end
end

# Exports {Compass::Canvas::Functions} to Sass.
module Sass::Script::Functions
  include Compass::Canvas::Functions
end
