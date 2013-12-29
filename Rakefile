require "bundler/gem_tasks"
require "ruby_danfe"

desc "Open an irb session preloaded ruby_danfe classes"
task :console do
  sh "irb -rubygems -I lib -r ruby_danfe.rb"
end

namespace :spec do
  namespace :fixtures do
    desc "Recreate all pdfs fixtures. Use this task always that output pdf format is changed."
    task :recreate_pdfs do
      Dir["spec/fixtures/*.xml"].each do |f|
        puts "Recreating #{f}.fixture.pdf"
        RubyDanfe.generate("#{f}.fixture.pdf", "#{f}")
      end
    end
  end
end
