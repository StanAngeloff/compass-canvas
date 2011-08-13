module Compass::Canvas
  module Functions
    # Functions for creating a Context interface.
    module Context
      # Creates a new {Compass::Canvas::Backend::Interface::Context}.
      #
      # @return [Compass::Canvas::Backend::Interface::Context] A new Context interface.
      def canvas_context(*args)
        Compass::Canvas::Backend::Interface::Context.new(*args)
      end
    end
  end
end
