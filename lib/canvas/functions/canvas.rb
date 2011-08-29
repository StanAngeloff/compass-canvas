module Compass::Canvas
  module Functions
    # Functions for creating a canvas backend.
    module Canvas
      # Creates a new {Compass::Canvas::Backend}.
      #
      # This function cannot be created in Sass as it is a variadic function.
      #
      # @return [Compass::Canvas::Backend] A new backend instance.
      def canvas(*args)
        backend = Compass.configuration.canvas_backend.sub(/^\w/) { |s| s.capitalize }
        begin
          klass = Compass::Canvas::Backend.const_get(backend)
        rescue NameError
          raise Compass::Canvas::Exception.new("(Compass::Canvas) '#{backend}' backend is not installed.")
        end
        klass.new(*Compass::Canvas::Functions.unpack(args).flatten)
      end

      # Gets the width of a {Compass::Canvas::Backend}.
      #
      # @return [Compass::Canvas::Backend] The width of the backend.
      def width_of(canvas)
        Sass::Script::Number.new(canvas.property(:width))
      end

      # Gets the height of a {Compass::Canvas::Backend}.
      #
      # @return [Compass::Canvas::Backend] The height of the backend.
      def height_of(canvas)
        Sass::Script::Number.new(canvas.property(:height))
      end

      # Gets the X position of the current path on a {Compass::Canvas::Backend}.
      #
      # @return [Compass::Canvas::Backend] The X position of the current backend path.
      def path_x(canvas)
        Sass::Script::Number.new(canvas.property(:x))
      end

      # Gets the Y position of the current path on a {Compass::Canvas::Backend}.
      #
      # @return [Compass::Canvas::Backend] The Y position of the current backend path.
      def path_y(canvas)
        Sass::Script::Number.new(canvas.property(:y))
      end
    end
  end
end
