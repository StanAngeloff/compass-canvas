# Canvas drawing support for Compass with Cairo backend(s).
#
# This module defines the current project version and useful helper functions.
#
# @author Stan Angeloff
module Compass::Canvas
  # The project and Gem version. When building a Gem file for release, the
  # version is stripped to X.Y.Z. If you are using a Git cloned-repository,
  # the version will end in +.git+.
  VERSION = '0.0.1.git'

  # The default backend for drawing.
  BACKEND = 'cairo'

  # Helper function to construct an absolute path to a given directory in
  # the project.
  #
  # @return [String] The absolute path to the directory.
  def self.path_to(directory)
    File.expand_path(File.join(File.dirname(__FILE__), '..', directory))
  end

  # Default exception class.
  class Exception < ::StandardError; end
end

require 'canvas/backend'
require 'canvas/configuration'
require 'canvas/functions'

# Register Canvas as a Compass framework.
#
# @see http://compass-style.org/docs/tutorials/extensions/
Compass::Frameworks.register('canvas',
  :stylesheets_directory => Compass::Canvas.path_to('stylesheets'),
  :templates_directory   => Compass::Canvas.path_to('templates')
)
