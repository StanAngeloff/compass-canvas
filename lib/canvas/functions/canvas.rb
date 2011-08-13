module Compass::Canvas
  module Functions
    # Functions for creating a canvas backend.
    module Canvas
      # Creates a new {Compass::Canvas::Backend}.
      #
      # @return [Compass::Canvas::Backend] A new backend instance.
      def canvas(*args)
        backend = Compass.configuration.canvas_backend.sub(/^\w/) { |s| s.capitalize }
        begin
          klass = Compass::Canvas::Backend.const_get(backend)
        rescue NameError
          raise Compass::Canvas::Exception.new("(Compass::Canvas) '#{backend}' backend is not installed.")
        end
        klass.new(*args)
      end
    end
  end
end
