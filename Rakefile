require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "cocoafish"
  gem.homepage = "http://cocoafish.com"
  gem.license = "MIT"
  gem.summary =  %Q{Cocoafish Ruby Client} 
  gem.description =  "A Ruby client for Cocoafish. For more information about Cocoafish, see http://cocoafish.com."
  gem.email = "info@cocoafish.com"
  gem.authors = ["Michael Goff", "Wei Kong"]
  gem.files = Dir["{lib}/**/*", "./*"]
  gem.add_runtime_dependency 'rest-client', '~> 1.6.3'
  gem.add_runtime_dependency 'json_pure', '~> 1.4.6'
  gem.add_runtime_dependency 'simple_oauth', '~> 0.1.4'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cocoafish #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('CHANGELOG*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
