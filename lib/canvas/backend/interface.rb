module Compass::Canvas::Backend
  # This module defines classes for parsing Sass types and constructing Ruby
  # objects for use in backend implementations.
  module Interface
    # Base class for all interface classes.
    #
    # This class unpacks Sass types to Ruby objects before passing them to a
    # backend implementation.
    class Base < Sass::Script::Literal
      # @return [String] The action to take, e.g., +move+, +line+.
      attr_accessor :action
      # @return [Array] The arguments to pass, e.g., +X+ and +Y+ coordinates.
      attr_accessor :args

      # Initializes a new instance of an interface class.
      #
      # @param [String] action The action to take, e.g., +move+, +line+.
      # @param [Array<Sass::Script::Literal>] args The arguments to pass.
      def initialize(action, *args)
        @action = action.value.to_sym
        unless self.respond_to?(@action)
          recognised = self.class.public_instance_methods - self.class.superclass.public_instance_methods
          raise Compass::Canvas::Exception.new("(#{self.class}) '#{@action}' is not a recognised action. Did you mean any of the following: '#{ recognised.join("', '") }'?")
        end
        arity = self.method(@action).arity.abs
        unless args.length >= arity
          raise Compass::Canvas::Exception.new("(#{self.class}.#{@action}) Wrong number of arguments (#{args.length} for #{arity}).")
        end
        @args = self.send(@action, *args)
      end

      # @raise [Compass::Canvas::Exception] Interface objects cannot be used as property values.
      def to_s(options = {})
        raise Compass::Canvas::Exception.new("(#{self.class}.#{@action}) Not available in this context.")
      end
    end
  end
end

require 'canvas/backend/interface/context';
require 'canvas/backend/interface/path';
require 'canvas/backend/interface/pattern';
