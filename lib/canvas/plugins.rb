module Compass::Canvas
  # This module includes external files in registered locations.
  #
  # @see Compass::Canvas::PLUGINS_PATH
  module Plugins
    module Functions; end
  end

  PLUGINS_PATH.each do |path|
    if File.exists?(path)
      Dir.glob(File.join(path, '**', '*.rb')).each do |plugin|
        require plugin
      end
    end
  end
end
