require 'base64'

# This module defines the base backend class for all implementations
module Compass::Canvas::Backend
  # Base abstract backend class.
  #
  # Each implementation must respond to four methods:
  # - {Compass::Canvas::Backend::Base::load_dependencies} - initializes the backend by loading third-party dependencies
  # - {Compass::Canvas::Backend::Base::read_canvas} - reads a canvas from a file
  # - {Compass::Canvas::Backend::Base::begin_canvas} - initialization code before the canvas is drawn
  # - {Compass::Canvas::Backend::Base::execute_one} - executes a single action on the canvas
  # - {Compass::Canvas::Backend::Base::to_blob} - clean up code, must return a
  #   +String+ representation of the canvas in a PNG format
  class Base < Sass::Script::Literal
    # @return [Fixnum] The width of the canvas, in pixels.
    attr_accessor :width
    # @return [Fixnum] The height of the canvas, in pixels.
    attr_accessor :height
    # @return [String] The external file where the backend will be loaded/saved in a PNG format.
    attr_accessor :file

    # Initializes a new instance of a backend class.
    #
    # @overload initialize(width, height, *actions)
    #   @param [Fixnum] width The width of the canvas, in pixels.
    #   @param [Fixnum] height The height of the canvas, in pixels.
    #   @param [Array<Object>] actions The actions to execute.
    # @overload initialize(file, width, height, *actions)
    #   @param [String] file The file where the backend will be saved in a PNG format.
    #   @param [Fixnum] width The width of the canvas, in pixels.
    #   @param [Fixnum] height The height of the canvas, in pixels.
    #   @param [Array<Object>] actions The actions to execute.
    # @overload initialize(file)
    #   @param [String] file An external file to read.
    def initialize(*args)
      load_dependencies
      if args[0].is_a?(String)
        file = args.shift
        file = Compass::Canvas.absolute_path_to(file) unless args[0].is_a?(Fixnum)
        @file = file
      end
      if args[0].is_a?(Fixnum)
        @width  = args.shift
        @height = args.shift
      end
      @actions  = args
      @executed = false
    end

    # Abstract method.
    #
    # Initializes the backend by loading third-party dependencies.
    #
    # @raise [Compass::Canvas::Exception] Backend implementation must override this method.
    def load_dependencies
      raise Compass::Canvas::Exception.new("(#{self.class}) Class must implement '#{this_method}'.")
    end

    # Abstract method.
    #
    # Reads a canvas from a file
    #
    # @raise [Compass::Canvas::Exception] Backend implementation must override this method.
    def read_canvas
      raise Compass::Canvas::Exception.new("(#{self.class}) Class must implement '#{this_method}'.")
    end

    # Abstract method.
    #
    # Initialization code before the canvas is drawn.
    #
    # @raise [Compass::Canvas::Exception] Backend implementation must override this method.
    def begin_canvas
      raise Compass::Canvas::Exception.new("(#{self.class}) Class must implement '#{this_method}'.")
    end

    # Abstract method.
    #
    # Executes a single action on the canvas.
    #
    # @raise [Compass::Canvas::Exception] Backend implementation must override this method.
    def execute_one(action, *args)
      raise Compass::Canvas::Exception.new("(#{self.class}) Class must implement '#{this_method}'.")
    end

    # Abstract method.
    #
    # Clean up code, must return a +String+ representation of the canvas in a PNG format.
    #
    # @raise [Compass::Canvas::Exception] Backend implementation must override this method.
    def to_blob
      raise Compass::Canvas::Exception.new("(#{self.class}) Class must implement '#{this_method}'.")
    end

    # Reads a property of the backend.
    #
    # This can be used to provide custom information about a backend, such as
    # width, height, the current point's position, etc.
    #
    # @param [String] name The property name.
    # @return [Object] The property value, or nil if it doesn't exist.
    def property(name)
      case name
      when :width;  return @width
      when :height; return @height
      else return nil
      end
    end

    # Creates an empty canvas and executes all stored actions.
    def execute
      return self if @executed
      if @width && @height
        begin_canvas
        execute_actions
      else
        read_canvas
      end
      @executed = true
      self
    end

    # Returns the canvas as a Base64 encoded Data URI or as a file on disk
    # depending on the configuration.
    def value
      execute
      if @file
        extension = '.png'
        filename  = @file.chomp(extension) + extension
        path      = File.join(Compass.configuration.images_path, filename)
        FileUtils.mkpath(File.dirname(path))
        File.open(path, 'wb') { |io| io << to_blob }
        filename
      else
        "url('data:image/png;base64,#{ Base64.encode64(to_blob).gsub("\n", '') }')"
      end
    end

    # Serializes the canvas as a Sass type
    def to_s(options = {})
      Sass::Script::String.new(value)
    end

    protected

    def execute_actions(actions = nil)
      actions ||= @actions
      actions.each do |child|
        if child.is_a?(Compass::Canvas::Backend::Interface::Base)
          action = child.action
          args   = child.args
        elsif child.is_a?(String)
          action = child.to_sym
          args   = []
        else
          raise Compass::Canvas::Exception.new("(#{self.class}) Unsupported action: #{child.inspect}")
        end
        execute_one(action, *args)
      end
    end

    private

    def this_method
      caller[0][/`([^']*)'/, 1]
    end
  end
end

require 'canvas/backend/interface';
require 'canvas/backend/cairo';
