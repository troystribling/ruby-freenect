require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby-freenect"
    gem.summary = gem.description = %Q{Ruby bindings for the libfreenect Kinect driver}
    gem.homepage = "https://github.com/troystribling/ruby-freenect"
    gem.authors = ["Troy Stribling"]

    gem.rdoc_options += ["--title", "FFI Freenect", "--main",  "README.rdoc", "--line-numbers"]
    gem.add_dependency("ffi", ">= 1.0.11")

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov_opts =  %q[--exclude "spec"]
end

task :spec => :check_dependencies

task :default => :spec
