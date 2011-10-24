# Help translating elements on code

# Q: Why don't use variables for offset or set margins?!
# A: For the fun of using Regexp ;)

dx = 14
dy = 40

File.open('ruby_danfe.rb', 'r') do |f|

  f.each_line do |l|
  
    if l =~ /pdf\.stroke_rectangle \[(-\d+|\d+), (\d+)\], (\d+), (\d+)/
      print "\tpdf.stroke_rectangle [#{$1.to_i+dx}, #{$2.to_i+dy}], #{$3}, #{$4}\n"
    elsif l =~ /\:at => \[(-\d+|\d+), (\d+)\]/
      print l.gsub(":at => [#{$1}, #{$2}]", ":at => [#{$1.to_i+dx}, #{$2.to_i+dy}]")
    else
      print l
    end
    
  end
  
end
