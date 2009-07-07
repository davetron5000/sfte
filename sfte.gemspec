spec = Gem::Specification.new do |s| 
  s.name = 'sfte'
  s.version = '0.1.0'
  s.author = 'David Copeland'
  s.email = 'davidcopeland@naildrivin5.com'
  s.homepage = 'http://github.com/davetron5000/sfte/tree/master'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Wraps Maven so taht test failures show up as "compile errors" for vim quickfix'
  s.files = %w(
lib/sfte.rb
bin/sfte
  )
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'sfte'
end

