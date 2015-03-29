Gem::Specification.new do |s|
  s.name        = 'parallel_tasker'
  s.version     = '0.1.1'
  s.summary     = "Simple Gem to help run tasks in parallel"
  s.description = "Collects tasks to be run, then execute in parallel, with maximum specified concurrency."
  s.authors     = ["Fabio Pugliese Ornellas"]
  s.email       = 'fabio.ornellas@gmail.com'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'guard', '~> 2.12', '>= 2.12.5'
  s.add_development_dependency 'guard-rspec', '~> 4.5'
  s.files       = Dir.glob('lib/**/*.rb')
  s.homepage    = 'https://github.com/fornellas/parallel_tasker'
  s.license     = 'GPL'
end
