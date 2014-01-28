module RubyDanfe
  class Cep
    def self.format(cep)
      cep.sub(/(\d{2})(\d{3})(\d{3})/, "\\1.\\2-\\3")
    end
  end
end
