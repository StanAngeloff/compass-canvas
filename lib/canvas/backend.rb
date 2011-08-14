require 'base64'

# This module defines the base backend class for all implementations
module Compass::Canvas::Backend
  # Base abstract backend class.
  #
  # Each implementation must respond to four methods:
  # - {Compass::Canvas::Backend::Base::load_dependencies} - initializes the backend by loading third-party dependencies
  # - {Compass::Canvas::Backend::Base::begin_canvas} - initialization code before the canvas is drawn
  # - {Compass::Canvas::Backend::Base::execute_action} - executes a single action on the canvas
  # - {Compass::Canvas::Backend::Base::to_blob} - clean up code, must return a
  #   +String+ representation of the canvas in a PNG format
  class Base < Sass::Script::Literal
    # @return [Fixnum] The width of the canvas, in pixels.
    attr_accessor :width
    # @return [Fixnum] The height of the canvas, in pixels.
    attr_accessor :height
    # @return [String] The external file where the Canvas will be read/written in a PNG format.
    attr_accessor :file

    # Initializes a new instance of a backend class.
    #
    # @overload initialize(width, height, *actions)
    #   @param [Fixnum] width The width of the canvas, in pixels.
    #   @param [Fixnum] height The height of the canvas, in pixels.
    #   @param [Array<Object>] actions The actions to execute.
    # @overload initialize(file)
    #   @param [String] file An external file to read.
    def initialize(*args)
      load_dependencies
      if (args.length == 1)
        file = args.shift
        if file.include?('url(')
          file = File.join(Compass.configuration.css_path, file.gsub(/^url\(['"]?|["']?\)$/, '').split('?').shift())
        else
          file = File.join(Compass.configuration.images_path, file.split('?').shift())
        end
        @file = file
      else
        @width  = args.shift
        @height = args.shift
      end
      @actions = args
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
    def execute_action(action, *args)
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

    # Creates an empty canvas and executes all stored actions.
    def execute
      begin_canvas
      @actions.each do |child|
        if child.is_a?(Compass::Canvas::Backend::Interface::Base)
          action = child.action
          args   = child.args
        elsif child.is_a?(String)
          action = child.to_sym
          args   = []
        else
          raise Compass::Canvas::Exception.new("(#{self.class}) Unsupported action: #{child.inspect}")
        end
        execute_action(action, *args)
      end
      self
    end

    # Serializes the canvas as a Base64 encoded Data URI.
    def to_s(options = {})
      execute
      Sass::Script::String.new("url('data:image/png;base64,#{ Base64.encode64(to_blob).gsub("\n", '') }')")
    end

    private

    def this_method
      caller[0][/`([^']*)'/, 1]
    end
  end
end

require 'canvas/backend/interface';
require 'canvas/backend/cairo';
