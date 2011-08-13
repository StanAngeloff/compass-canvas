module Compass::Canvas
  module Functions
    # Functions for creating a Path interface.
    module Path
      # Creates a new {Compass::Canvas::Backend::Interface::Path}.
      #
      # @return [Compass::Canvas::Backend::Interface::Path] A new Path interface.
      def canvas_path(*args)
        Compass::Canvas::Backend::Interface::Path.new(*args)
      end
    end
  end
end
