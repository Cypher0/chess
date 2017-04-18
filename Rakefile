require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  lab = Rake.application.original_dir
  task.pattern = "#{lab}/spec/*_spec.rb"
  task.rspec_opts = ["-I#{lab}/spec", "-I#{lab}/spec/solution", '-f documentation', '-r ./rspec_config']
  task.verbose = false
end

task default: :spec
