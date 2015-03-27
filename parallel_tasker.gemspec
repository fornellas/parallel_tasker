Gem::Specification.new do |s|
  s.name        = 'parallel_tasker'
  s.version     = '0.0.0'
  s.summary     = "Simple Gem to help run tasks in parallel"
  s.description = "Simple Gem that collects tasks to be run, then execute them with maximum specified parallelism."
  s.authors     = ["Fabio Pugliese Ornellas"]
  s.email       = 'fabio.ornellas@gmail.com'
  s.files       = Dir.glob('lib/**/*.rb')
  s.homepage    = 'https://github.com/fornellas/parallel_tasker'
  s.license     = 'GPL'
end
