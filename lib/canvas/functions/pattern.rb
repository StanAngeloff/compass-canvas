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
        canvas_pattern(Sass::Script::String.new('brush'), *args)
      end

      # Constructs a dash pattern array from positive On/Off lengths.
      #
      # This function cannot be created in Sass as it is a variadic function.
      def dash_pattern(*args)
        canvas_pattern(Sass::Script::String.new('dash_pattern'), *args)
      end

      # Constructs a mask from a canvas.
      #
      # This function cannot be created in Sass as it is a variadic function.
      def mask(*args)
        canvas_pattern(Sass::Script::String.new('mask'), *args)
      end
    end
  end
end
