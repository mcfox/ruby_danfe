module RubyDanfe
  class Phone
    def self.format(phone)
      if phone.length == 10
        phone.sub(/(\d{2})(\d{4})(\d{4})/, "(\\1) \\2-\\3")
      else
        phone.sub(/(\d{2})(\d{5})(\d{4})/, "(\\1) \\2-\\3")
      end
    end
  end
end
