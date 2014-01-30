module RubyDanfe
  class Cnpj
    def self.format(cnpj)
      cnpj.sub(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, "\\1.\\2.\\3/\\4-\\5")
    end
  end
end
