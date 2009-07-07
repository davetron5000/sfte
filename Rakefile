require 'rake/clean'
require 'rake/gempackagetask'

spec = eval(File.read('sfte.gemspec'))

Rake::GemPackageTask.new(spec) do |pkg|
end

task :default => :package
