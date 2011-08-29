module Compass::Canvas::Plugins::Functions
  def slow_drop_shadow(x, y, radius, brush, *args)
    Sass::Script::List.new(
      [Sass::Script::String.new('push')].concat([canvas_context(Sass::Script::String.new('slow_blur'), radius, args)]).concat([Sass::Script::String.new('pop'), Sass::Script::String.new('store')]).concat([
        brush,
        Sass::Script::String.new('save'),
        canvas_context(Sass::Script::String.new('translate'), x, y),
        canvas_pattern(Sass::Script::String.new('mask'), Sass::Script::String.new('retrieve')),
        Sass::Script::String.new('restore')
      ].concat(args)),
      :space
    )
  end
end
