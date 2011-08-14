module Compass::Canvas::Backend::Interface
  # Interface Context class.
  class Context < Base
    # Unpacks argument +width+ from Sass to a Ruby object.
    def line_width(width)
      [width.value]
    end

    # Unpacks argument +type+ from Sass to a Ruby object.
    def line_cap(type)
      [type.value]
    end

    # Unpacks argument +type+ from Sass to a Ruby object.
    def line_join(type)
      [type.value]
    end

    # Unpacks argument +limit+ from Sass to a Ruby object.
    def miter_limit(limit)
      [limit.value]
    end

    # Unpacks argument +type+ from Sass to a Ruby object.
    def antialias(type)
      if type.is_a?(Sass::Script::Color)
        [type.to_s]
      else
        [type.value]
      end
    end

    # Unpacks argument +type+ from Sass to a Ruby object.
    def fill_rule(type)
      [type.value]
    end

    # Unpacks argument +level+ from Sass to a Ruby object.
    def tolerance(level)
      [level.value]
    end

    # Unpacks arguments +X+ and +Y+ from Sass to Ruby objects.
    def translate(x, y)
      [x.value, y.value]
    end

    # Unpacks arguments +X+ and +Y+ from Sass to Ruby objects.
    def scale(x, y)
      [x.value, y.value]
    end

    # Unpacks argument +angle+ from Sass to a Ruby object.
    def rotate(angle)
      [angle.value * (Math::PI / 180.0)]
    end

    # Unpacks matrix arguments from Sass to Ruby objects.
    def transform(xx, yx, xy, yy, x0, y0)
      [xx.value, yx.value, xy.value, yy.value, x0.value, y0.value]
    end
  end
end
