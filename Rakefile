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
      Dir["spec/fixtures/nfe*.xml"].each do |f|
        puts "Recreating #{f}.fixture.pdf"
        RubyDanfe.generate("#{f}.fixture.pdf", "#{f}")
      end

      puts "Recreating spec/fixtures/4_decimals_nfe_simples_nacional.xml.fixture.pdf"
      RubyDanfe.options = {"quantity_decimals" => 4}
      RubyDanfe.generate("spec/fixtures/4_decimals_nfe_simples_nacional.xml.fixture.pdf", "spec/fixtures/4_decimals_nfe_simples_nacional.xml")

      Dir["spec/fixtures/cte*.xml"].each do |f|
        puts "Recreating #{f}.fixture.pdf"
        RubyDanfe.generate("#{f}.fixture.pdf", "#{f}", :dacte)
      end

      Dir["spec/fixtures/nfse*.xml"].each do |f|
        puts "Recreating #{f}.fixture.pdf"
        RubyDanfe.generate("#{f}.fixture.pdf", "#{f}", :danfse)
      end
    end
  end
end
