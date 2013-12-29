require "../lib/ruby_danfe"

if ARGV.size == 0
  puts "Usage: generate.rb <filename>"
  exit(1)
end

RubyDanfe.generate("#{ARGV[0]}.pdf", ARGV[0])
