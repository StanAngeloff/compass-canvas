module Compass::Canvas::Backend::Interface
  # Interface Path class.
  class Path < Base
    # Unpacks arguments +X+ and +Y+ from Sass to Ruby objects.
    def move(x, y)
      [x.value, y.value]
    end

    # Unpacks arguments +X+ and +Y+ from Sass to Ruby objects.
    def line(x, y)
      [x.value, y.value]
    end

    # Unpacks arguments +X+[1..3] and +Y+[1..3] from Sass to Ruby objects.
    def curve(x1, y1, x2, y2, x3, y3)
      [x1.value, y1.value, x2.value, y2.value, x3.value, y3.value]
    end

    # Unpacks arguments +X+[1..2] and +Y+[1..2] from Sass to Ruby objects.
    def quadratic_curve(x1, y1, x2, y2)
      [x1.value, y1.value, x2.value, y2.value]
    end

    # Unpacks arguments +X+, +Y+, +radius+ and +angle+[1..2] from Sass to Ruby objects.
    def arc(x, y, radius, angle1, angle2)
      [x.value, y.value, radius.value, angle1.value * (Math::PI / 180.0), angle2.value * (Math::PI / 180.0)]
    end

    # @see {arc}
    def arc_reverse(*args)
      arc(*args)
    end
  end
end
