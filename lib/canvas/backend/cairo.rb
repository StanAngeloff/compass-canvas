require 'stringio'

module Compass::Canvas::Backend
  # Cairo backend implementation.
  class Cairo < Base
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

    # Creates a new +ImageSurface+ and binds a new context to it.
    def begin_canvas
      if @file
        @surface = ::Cairo::ImageSurface.from_png(@file)
      else
        @surface = ::Cairo::ImageSurface.new(::Cairo::FORMAT_ARGB32, @width, @height)
      end
      @context = ::Cairo::Context.new(@surface)
      @context.set_line_width(1)
    end

    # Executes a single action on the context bound to the surface.
    def execute_action(action, *args)
      case action
      when :move
        @context.move_to(*args)
      when :line
        @context.line_to(*args)
      when :curve
        @context.curve_to(*args)
      when :arc
        @context.arc(*args)
      when :paint
        @context.paint(*args)
      when :stroke
        @context.stroke_preserve(*args)
      when :fill
        @context.fill_preserve(*args)
      when :line_width
        @context.set_line_width(*args)
      when :push
        @context.push_group
      when :pop
        @context.pop_group_to_source
      when :group
        @context.new_sub_path
      when :clip
        @context.clip_preserve
      when :unclip
        @context.reset_clip
      when :close
        @context.close_path
      when :reset
        @context.new_path
      when :save
        @context.save
      when :restore
        @context.restore
      when :antialias
        @context.set_antialias(::Cairo::const_get("ANTIALIAS_#{ args[0].upcase }"))
      when :fill_rule
        @context.set_fill_rule(::Cairo::const_get("FILL_RULE_#{ args[0].gsub('-', '_').upcase }"))
      when :tolerance
        @context.set_tolerance(*args)
      when :line_cap
        @context.set_line_cap(::Cairo::const_get("LINE_CAP_#{ args[0].gsub('-', '_').upcase }"))
      when :line_join
        @context.set_line_join(::Cairo::const_get("LINE_JOIN_#{ args[0].gsub('-', '_').upcase }"))
      when :miter_limit
        @context.set_miter_limit(*args)
      when :dash_pattern
        if args.length > 1
          @context.set_dash(args)
        else
          @context.set_dash(nil, 0)
        end
      when :translate
        @context.translate(*args)
      when :scale
        @context.scale(*args)
      when :rotate
        @context.rotate(*args)
      when :transform
        @context.transform(::Cairo::Matrix.new(*args))
      when :mask
        if args[0].is_a?(Compass::Canvas::Backend::Cairo)
          surface = args.shift.execute.surface
          if args.length == 1
            pattern = ::Cairo::SurfacePattern.new(surface)
            pattern.set_extend(::Cairo::const_get("EXTEND_#{ args[0].upcase }"))
            @context.mask(pattern)
          else
            x = args.shift if args.length
            y = args.shift if args.length
            @context.mask(surface, x || 0, y || 0)
          end
        else
          raise Compass::Canvas::Exception.new("(#{self.class}.#{action}) Unsupported canvas, Cairo can only mask with Cairo: #{args.inspect}")
        end
      when :brush
        case args[0]
        when :solid
          @context.set_source_rgba(*args[1])
        when :linear, :radial
          gradient = ::Cairo::const_get("#{ args[0].to_s.sub(/^\w/) { |s| s.capitalize } }Pattern").new(*args[1])
          args[2].each { |value| gradient.add_color_stop_rgba(*value) }
          @context.set_source(gradient)
        when :canvas
          if args[1].is_a?(Compass::Canvas::Backend::Cairo)
            pattern = ::Cairo::SurfacePattern.new(args[1].execute.surface)
            if args.length > 1
              pattern.set_extend(::Cairo::const_get("EXTEND_#{ args[2].upcase }"))
            end
            @context.set_source(pattern)
          else
            raise Compass::Canvas::Exception.new("(#{self.class}.#{action}) Unsupported canvas, Cairo can only paint with Cairo: #{args.inspect}")
          end
        else
          raise Compass::Canvas::Exception.new("(#{self.class}.#{action}) Unsupported type (supported types are 'solid', 'linear', 'radial'): #{args.inspect}")
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
  end
end
