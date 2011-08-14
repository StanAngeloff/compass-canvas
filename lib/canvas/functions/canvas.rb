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
        klass.new(*unpack(args).flatten)
      end

      protected

      def unpack(value)
        if value.is_a?(Compass::Canvas::Backend::Interface::Base)
          value
        elsif value.is_a?(Sass::Script::Literal)
          unpack(value.value)
        elsif value.is_a?(Array)
          value.map { |child| unpack(child) }
        else
          value
        end
      end
    end
  end
end
