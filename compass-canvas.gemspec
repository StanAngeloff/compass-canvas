Gem::Specification.new do |s|
  s.name     = 'compass-canvas'
  s.summary  = 'Canvas drawing support for Compass with Cairo backend(s).'

  s.version  = IO.read(File.join(File.dirname(__FILE__), 'lib/canvas.rb')).scan(/VERSION\s*=\s*'([^']+)/).shift.shift.gsub('.git', '')
  s.date     = Time.now

  s.authors  = ['Stan Angeloff']
  s.email    = ['stanimir@angeloff.name']
  s.homepage = 'http://StanAngeloff.github.com/compass-canvas/'

  s.require_paths = ['lib']

  s.add_runtime_dependency('compass', '~> 0.11')
  s.add_runtime_dependency('cairo',   '~> 1.10')

  s.files  = ['README.md', 'LICENSE.md']
  s.files += Dir.glob('lib/**/*.*')
  s.files += Dir.glob('stylesheets/**/*.*')
  s.files += Dir.glob('plugins/**/*.*')
end
