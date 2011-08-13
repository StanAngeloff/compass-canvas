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
  end
end

# Exports {Compass::Canvas::Functions} to Sass.
module Sass::Script::Functions
  include Compass::Canvas::Functions
end
