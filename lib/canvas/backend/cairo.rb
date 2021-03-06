require 'stringio'

module Compass::Canvas::Backend
  # Cairo backend implementation.
  class Cairo < Base
    # @return [::Cairo::ImageSurface] The internal image surface.
    attr_accessor :surface

    # Loads the +cairo+ gem dependency. If it is not on +$LOAD_PATH+, attempts
    # to load RubyGems.
    def load_dependencies
      begin
        require 'cairo'
      rescue LoadError
        require 'rubygems'
        begin
          require 'cairo'
        rescue LoadError
          puts "Compass::Canvas\n_______________\n\n"
          puts "Unable to load Cairo backend. Please install it with the following command:\n\n"
          puts "  gem install cairo\n\n"
          puts "For more information, please visit https://github.com/rcairo/rcairo"
          raise
        end
      end
    end

    # Reads a property of the Cairo backend.
    #
    # This can be used to obtain information about the width/height of the
    # surface as well as the current point's X/Y coordinates.
    #
    # @param [String] name The property name.
    # @return [Object] The property value, or nil if it doesn't exist.
    def property(name)
      execute
      case name
      when :width;  return @surface.width
      when :height; return @surface.height
      when :x;      return @context.current_point[0]
      when :y;      return @context.current_point[1]
      else return nil
      end
    end

    # Creates a new +ImageSurface+ from a file
    def read_canvas
      @surface = ::Cairo::ImageSurface.from_png(@file)
      bind_context
    end

    # Creates a new +ImageSurface+ and binds a new context to it.
    def begin_canvas
      if @width && @height
        @surface = ::Cairo::ImageSurface.new(::Cairo::FORMAT_ARGB32, @width, @height)
      else
        @surface = ::Cairo::ImageSurface.from_png(@file)
      end
      bind_context
    end

    # Executes a single action on the context bound to the surface.
    def execute_one(action, *args)
      case action
      when Compass::Canvas::Actions::MOVE
        @context.move_to(*args)
      when Compass::Canvas::Actions::LINE
        @context.line_to(*args)
      when Compass::Canvas::Actions::CURVE
        @context.curve_to(*args)
      when Compass::Canvas::Actions::QUADRATIC_CURVE
        x1, y1, x2, y2 = args
        x, y = @context.current_point
        @context.curve_to(
          x  + 2.0 / 3.0 * (x1 - x),  y  + 2.0 / 3.0 * (y1 - y),
          x2 + 2.0 / 3.0 * (x1 - x2), y2 + 2.0 / 3.0 * (y1 - y2),
          x2, y2
        )
      when Compass::Canvas::Actions::ARC
        @context.arc(*args)
      when Compass::Canvas::Actions::ARC_REVERSE
        @context.arc_negative(*args)
      when Compass::Canvas::Actions::PAINT
        @context.paint(*args)
      when Compass::Canvas::Actions::STROKE
        @context.stroke_preserve(*args)
      when Compass::Canvas::Actions::FILL
        @context.fill_preserve(*args)
      when Compass::Canvas::Actions::LINE_WIDTH
        @context.set_line_width(*args)
      when Compass::Canvas::Actions::PUSH
        @context.push_group
      when Compass::Canvas::Actions::POP
        @context.pop_group_to_source
      when Compass::Canvas::Actions::STORE
        @sources.push(@context.source)
      when Compass::Canvas::Actions::RETRIEVE
        @context.set_source(@sources.pop)
      when Compass::Canvas::Actions::GROUP
        @context.new_sub_path
      when Compass::Canvas::Actions::CLIP
        @context.clip_preserve
      when Compass::Canvas::Actions::UNCLIP
        @context.reset_clip
      when Compass::Canvas::Actions::CLOSE
        @context.close_path
      when Compass::Canvas::Actions::RESET
        @context.new_path
      when Compass::Canvas::Actions::SAVE
        @context.save
      when Compass::Canvas::Actions::RESTORE
        @context.restore
      when Compass::Canvas::Actions::ANTIALIAS
        @context.set_antialias(constant('ANTIALIAS', args))
      when Compass::Canvas::Actions::FILL_RULE
        @context.set_fill_rule(constant('FILL_RULE', args))
      when Compass::Canvas::Actions::TOLERANCE
        @context.set_tolerance(*args)
      when Compass::Canvas::Actions::LINE_CAP
        @context.set_line_cap(constant('LINE_CAP', args))
      when Compass::Canvas::Actions::LINE_JOIN
        @context.set_line_join(constant('LINE_JOIN', args))
      when Compass::Canvas::Actions::MITER_LIMIT
        @context.set_miter_limit(*args)
      when Compass::Canvas::Actions::DASH_PATTERN
        # If at least two lengths exist, create a new pattern
        if args.length > 1
          @context.set_dash(args)
        # Otherwise return to a solid stroke
        else
          @context.set_dash(nil, 0)
        end
      when Compass::Canvas::Actions::TRANSLATE
        @context.translate(*args)
      when Compass::Canvas::Actions::SCALE
        @context.scale(*args)
      when Compass::Canvas::Actions::ROTATE
        @context.rotate(*args)
      when Compass::Canvas::Actions::TRANSFORM
        @context.transform(::Cairo::Matrix.new(*args))
      when Compass::Canvas::Actions::MASK
        type = args.shift
        if type.is_a?(Compass::Canvas::Backend::Cairo)
          surface = type.execute.surface
          if args.length == 1
            pattern = ::Cairo::SurfacePattern.new(surface)
            pattern.set_extend(constant('EXTEND', args))
            @context.mask(pattern)
          else
            x = args.shift if args.length > 0
            y = args.shift if args.length > 0
            @context.mask(surface, x || 0, y || 0)
          end
        elsif type == Compass::Canvas::Actions::RETRIEVE
          @context.mask(@sources.pop)
        else
          raise Compass::Canvas::Exception.new("(#{self.class}.#{action}) Unsupported canvas, Cairo can only mask with Cairo: #{type.inspect}")
        end
      when Compass::Canvas::Actions::BRUSH
        type = args.shift
        case type
        when Compass::Canvas::Constants::SOLID
          components = args.shift
          @context.set_source_rgba(*components)
        when Compass::Canvas::Constants::LINEAR, Compass::Canvas::Constants::RADIAL
          coordinates = args.shift
          stops       = args.shift
          gradient    = ::Cairo::const_get("#{ type.to_s.sub(/^\w/) { |s| s.capitalize } }Pattern").new(*coordinates)
          stops.each { |value| gradient.add_color_stop_rgba(*value) }
          @context.set_source(gradient)
        when Compass::Canvas::Constants::CANVAS
          canvas = args.shift
          if canvas.is_a?(Compass::Canvas::Backend::Cairo)
            pattern = ::Cairo::SurfacePattern.new(canvas.execute.surface)
            pattern.set_extend(constant('EXTEND', args)) if args.length > 0
            @context.set_source(pattern)
          else
            raise Compass::Canvas::Exception.new("(#{self.class}.#{action}) Unsupported canvas, Cairo can only paint with Cairo: #{canvas.inspect}")
          end
        else
          raise Compass::Canvas::Exception.new("(#{self.class}.#{action}) Unsupported type (supported types are 'solid', 'linear', 'radial'): #{type.inspect}")
        end
      when Compass::Canvas::Actions::SLOW_BLUR
        radius = args.shift
        @context.pseudo_blur(radius) do
          execute_actions(args)
        end
      else
        raise Compass::Canvas::Exception.new("(#{self.class}) '#{action}' is not supported.")
      end
    end

    # Serializes the +ImageSurface+ to a +String+.
    def to_blob
      stream = StringIO.new
      @surface.write_to_png(stream)
      stream.string
    end

    private

    def bind_context
      @context = ::Cairo::Context.new(@surface)
      @context.set_line_width(1)
      @sources = []
    end

    def constant(name, *args)
      ::Cairo::const_get("#{ name.upcase }_#{ args.join('_').gsub('-', '_').upcase }")
    end
  end
end
