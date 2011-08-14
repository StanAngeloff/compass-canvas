module Compass::Canvas::Backend::Interface
  # Interface Pattern class.
  class Pattern < Base
    # Unpacks brush arguments to a Ruby object.
    def brush(*args)
      if args.length == 1
        type = args.shift
        if type.is_a?(Sass::Script::Color)
          [Compass::Canvas::Constants::SOLID, Pattern.split(type)]
        elsif type.is_a?(Sass::Script::String) && type.value == Compass::Canvas::Actions::RETRIEVE.to_s
          [Compass::Canvas::Actions::RETRIEVE]
        elsif type.is_a?(Compass::Canvas::Backend::Base)
          [Compass::Canvas::Constants::CANVAS, type]
        else
          raise Compass::Canvas::Exception.new("(#{self.class}.#{@action}) Unsupported solid brush type: #{type.inspect}")
        end
      elsif args.length == 2
        canvas  = args.shift
        extends = args.shift
        if canvas.is_a?(Compass::Canvas::Backend::Base) && extends.is_a?(Sass::Script::String)
          [Compass::Canvas::Constants::CANVAS, canvas, extends.value]
        else
          raise Compass::Canvas::Exception.new("(#{self.class}.#{@action}) Unsupported pattern brush type: #{canvas.inspect}")
        end
      elsif args.length > 4
        index = 0
        index = index + 1 while index < args.length && args[index].is_a?(Sass::Script::Number)
        type = Compass::Canvas::Constants::LINEAR if index == 4
        type = Compass::Canvas::Constants::RADIAL if index == 6
        if type
          [type, args.slice(0, index).map { |value| value.value }, Pattern.stops(args.slice(index, args.length))]
        else
          raise Compass::Canvas::Exception.new("(#{self.class}.#{@action}) Unsupported gradient brush type: #{args.inspect}")
        end
      else
        raise Compass::Canvas::Exception.new("(#{self.class}.#{@action}) Unsupported brush type: #{args.inspect}")
      end
    end

    # Unpacks dash +pattern+ arguments to Ruby objects.
    def dash_pattern(*pattern)
      pattern.map { |value| value.value }
    end

    # Unpacks +canvas+ and optional arguments to a Ruby object.
    def mask(*args)
      type = args.shift
      if type.is_a?(Sass::Script::String) && type.value == Compass::Canvas::Actions::RETRIEVE.to_s
        type = Compass::Canvas::Actions::RETRIEVE
      end
      [type].concat(args.map { |value| value.value })
    end

    private

    def self.split(value)
      [value.red / 255.0, value.green / 255.0, value.blue / 255.0, value.alpha]
    end

    def self.stops(list)
      result      = []
      last_offset = 0
      list.each_with_index do |value, index|
        if value.is_a?(Sass::Script::Color)
          if index > 0
            if index == list.length - 1
              offset = 100
            else
              next_index  = 0
              next_offset = nil
              list.slice(index, list.length).each do |next_value|
                next_index = next_index + 1
                if next_value.is_a?(Sass::Script::List)
                  next_value.value.each { |child| next_offset = child.value if child.is_a?(Sass::Script::Number) }
                  break
                end
              end
              next_offset ||= 100
              offset = last_offset + (next_offset - last_offset) / next_index
            end
          else
            offset = 0
          end
          last_offset = offset
          result.push([last_offset / 100.0].concat(Pattern.split(value)))
        elsif value.is_a?(Sass::Script::List)
          color = nil
          value.value.each do |child|
            color       = child if child.is_a?(Sass::Script::Color)
            last_offset = child.value if child.is_a?(Sass::Script::Number)
          end
          result.push([last_offset / 100.0].concat(Pattern.split(color))) if color
        else
          raise Compass::Canvas::Exception.new("(#{self.class}) Unsupported gradient brush color-stop: #{value.inspect}")
        end
      end
      result
    end
  end
end
