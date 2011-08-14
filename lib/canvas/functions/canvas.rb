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
    end
  end
end
