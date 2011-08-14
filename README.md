compass-canvas
==============

### Canvas drawing support for Compass with Cairo backend(s)

Description
-----------

Canvas is a Compass plugin that provides a drawing surface similar to the `<canvas>` element in JavaScript and [Turtle graphics][turtle] in other programming languages.
It uses [Cairo][cairo] as a back-end to perform all graphics operations.
Canvas supports anti-aliasing, vector graphics, gradients, masks, clipping, complex operations like drop shadow and many more.

  [turtle]: http://en.wikipedia.org/wiki/Turtle_graphics
  [cairo]:  http://en.wikipedia.org/wiki/Cairo_(graphics)

Installation
------------

Installation is done through [RubyGems][gems]:

    gem install compass-canvas

### Dependencies

The `compass-canvas` gem depends on the `cairo` gem. In order to install both gems, you must have Cairo's development files present on your system.
You can usually install these using your OS package manager.

#### Ubuntu

    sudo apt-get install libcairo2-dev

  [gems]: http://rubygems.org/

Example
-------

    @import 'canvas';

    $shape: triangle(10, 10, 310, 10, 160, 190);

    html {
      background: canvas(320, 200,
        $shape
        brush(10, 10, 160, 100, rgba(red, 0.5) 50%, rgba(red, 0.75))
        fill
        reset
        save
          translate(40, 20)
          scale(0.75, 0.75)
          $shape
          brush(black)
          stroke
          brush(10, 10, 160, 100, rgba(blue, 0.75) 50%, rgba(blue, 0.5))
          fill
        restore
      ) no-repeat 50% 50%;
    }

License
-------

Canvas is licensed under the MIT License.

## [Documentation](http://StanAngeloff.github.com/compass-canvas/)

[RDoc is available][rdoc] for the entire project.

For more information on Cairo, visit [The Cairo graphics tutorial][cairo-tutorial].

For a complete reference on Cairo methods, visit [Pycairo documentation][pycairo].

  [rdoc]:           http://rubydoc.info/gems/compass-canvas/frames
  [cairo-tutorial]: http://zetcode.com/tutorials/cairographicstutorial/
  [pycairo]:        http://cairographics.org/documentation/pycairo/3/reference/context.html#class-context

### Copyright

> Copyright (c) 2011 Stan Angeloff. See [LICENSE.md](https://github.com/StanAngeloff/compass-canvas/blob/master/LICENSE.md) for details.
