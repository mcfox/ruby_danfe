module RubyDanfe
  class Ie
    def self.format(ie, uf)
      uf = uf.upcase

      if ["AL", "AP", "MA", "ES", "MS", "PI", "TO"].include?(uf)
        formated_ie = ie
      end

      if ["CE", "PB", "RR", "SE"].include?(uf)
        formated_ie = ie.sub(/(\d{8})(\d{1})/, "\\1-\\2")
      end

      if ["AM", "GO"].include?(uf)
        formated_ie = ie.sub(/(\d{2})(\d{3})(\d{3})(\d{1})/, "\\1.\\2.\\3-\\4")
      end

      case uf
      when "SP"
        if ie.length == 12
          formated_ie = ie.sub(/(\d{3})(\d{3})(\d{3})(\d{3})/, "\\1.\\2.\\3.\\4")
        else
          formated_ie = ie.sub(/(\w{1})(\d{8})(\d{1})(\d{3})/, "\\1-\\2.\\3/\\4")
        end
      when "BA"
        if ie.length == 8
          formated_ie = ie.sub(/(\d{6})(\d{2})/, "\\1-\\2")
        else
          formated_ie = ie.sub(/(\d{7})(\d{2})/, "\\1-\\2")
        end
      when "RO"
        if ie.length == 9
          formated_ie = ie.sub(/(\d{3})(\d{5})(\d{1})/, "\\1.\\2-\\3")
        else
          formated_ie = ie.sub(/(\d{13})(\d{1})/, "\\1-\\2")
        end
      when "RN"
        if ie.length == 9
          formated_ie = ie.sub(/(\d{2})(\d{3})(\d{3})(\d{1})/, "\\1.\\2.\\3-\\4")
        else
          formated_ie = ie.sub(/(\d{2})(\d{1})(\d{3})(\d{3})(\d{1})/, "\\1.\\2.\\3.\\4-\\5")
        end
      when "AC"
        formated_ie = ie.sub(/(\d{2})(\d{3})(\d{3})(\d{3})(\d{2})/, "\\1.\\2.\\3/\\4-\\5")
      when "DF"
        formated_ie = ie.sub(/(\d{11})(\d{2})/, "\\1-\\2")
      when "MG"
        formated_ie = ie.sub(/(\d{3})(\d{3})(\d{3})(\d{4})/, "\\1.\\2.\\3/\\4")
      when "MT"
        formated_ie = ie.sub(/(\d{10})(\d{1})/, "\\1-\\2")
      when "RJ"
        formated_ie = ie.sub(/(\d{2})(\d{3})(\d{2})(\d{1})/, "\\1.\\2.\\3-\\4")
      when "PR"
        formated_ie = ie.sub(/(\d{8})(\d{2})/, "\\1-\\2")
      when "RS"
        formated_ie = ie.sub(/(\d{3})(\d{7})/, "\\1/\\2")
      when "PE"
        formated_ie = ie.sub(/(\d{7})(\d{2})/, "\\1-\\2")
      when "PA"
        formated_ie = ie.sub(/(\d{2})(\d{6})(\d{1})/, "\\1-\\2-\\3")
      when "SC"
        formated_ie = ie.sub(/(\d{3})(\d{3})(\d{3})/, "\\1.\\2.\\3")
      end

      formated_ie
    end
  end
end
