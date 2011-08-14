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

      # Constructs a slow-blur group.
      #
      # This function cannot be created in Sass as it is a variadic function.
      def slow_blur(radius, *args)
        canvas_context(Sass::Script::String.new('slow_blur'), *[radius].concat(args))
      end
    end
  end
end
