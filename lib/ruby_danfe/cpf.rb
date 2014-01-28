module RubyDanfe
  class Cpf
    def self.format(cpf)
      cpf.sub(/(\d{3})(\d{3})(\d{3})(\d{2})/, "\\1.\\2.\\3-\\4")
    end
  end
end
