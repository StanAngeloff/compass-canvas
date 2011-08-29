# Canvas drawing support for Compass with Cairo backend(s).
#
# This module defines the current project version and useful helper functions.
#
# @author Stan Angeloff
module Compass::Canvas
  # The project and Gem version. When building a Gem file for release, the
  # version is stripped to X.Y.Z. If you are using a Git cloned-repository,
  # the version will end in +.git+.
  VERSION = '0.0.5.git'

  # The default backend for drawing.
  BACKEND = 'cairo'

  # Helper function to construct an absolute path to a given directory in
  # the project.
  #
  # @return [String] The absolute path to the directory.
  def self.path_to(directory)
    File.expand_path(File.join(File.dirname(__FILE__), '..', directory))
  end

  # Helper function to normalize a CSS path to a filesystem path.
  #
  # @param [String] file A CSS file, usually with url(..) and optionally a cache buster.
  # @return [String] The absolute filesystem path.
  def self.absolute_path_to(file)
    if file.include?('url(')
      file = File.join(Compass.configuration.css_path, file.gsub(/^url\(['"]?|["']?\)$/, ''))
    else
      file = File.join(Compass.configuration.images_path, file)
    end
    file.split('?').shift()
  end

  # Locations where plug-ins are installed. These paths are scanned for *.rb files
  # and loaded in order.
  PLUGINS_PATH = [
    Compass::Canvas.path_to('plugins'),
    File.join(ENV['HOME'], '.compass-canvas', 'plugins'),
    File.join(Dir.getwd, 'plugins')
  ]

  # Default exception class.
  class Exception < ::StandardError; end
end

require 'canvas/actions'
require 'canvas/constants'
require 'canvas/backend'
require 'canvas/configuration'
require 'canvas/plugins'
require 'canvas/functions'

# Register Canvas as a Compass framework.
#
# @see http://compass-style.org/docs/tutorials/extensions/
Compass::Frameworks.register('canvas',
  :stylesheets_directory => Compass::Canvas.path_to('stylesheets'),
  :templates_directory   => Compass::Canvas.path_to('templates')
)
