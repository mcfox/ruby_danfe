require "../lib/ruby_danfe"

if ARGV.size == 0
  puts "Usage: generate.rb <filename> <type>"
  exit(1)
end

type = (ARGV[1] || "danfe").to_sym

RubyDanfe.generate("#{ARGV[0]}.pdf", ARGV[0], type)
