require "../lib/ruby_danfe"

if ARGV.size == 0
  puts "Usage: generate.rb <filename>"
  exit(1)
end

RubyDanfe.generate("nfce.pdf", ARGV[0], :danfe_nfce)