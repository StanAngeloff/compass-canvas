module Compass::Canvas
  module Functions
    # Functions for creating a Pattern interface.
    module Pattern
      # Creates a new {Compass::Canvas::Backend::Interface::Pattern}.
      #
      # @return [Compass::Canvas::Backend::Interface::Pattern] A new Pattern interface.
      def canvas_pattern(*args)
        Compass::Canvas::Backend::Interface::Pattern.new(*args)
      end

      # Constructs a paint pattern.
      #
      # This function cannot be created in Sass as it is a variadic function.
      def brush(*args)
        canvas_pattern(Sass::Script::String.new(Compass::Canvas::Actions::BRUSH), *args)
      end

      # Constructs a dash pattern array from positive On/Off lengths.
      #
      # This function cannot be created in Sass as it is a variadic function.
      def dash_pattern(*args)
        canvas_pattern(Sass::Script::String.new(Compass::Canvas::Actions::DASH_PATTERN), *args)
      end

      # Constructs a mask from a canvas.
      #
      # This function cannot be created in Sass as it is a variadic function.
      def mask(*args)
        canvas_pattern(Sass::Script::String.new(Compass::Canvas::Actions::MASK), *args)
      end
    end
  end
end
