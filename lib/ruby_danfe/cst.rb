module RubyDanfe
  class Cst
    def self.to_danfe(xml)
      value = origin(xml)

      if csosn?(xml)
        value += xml.css("ICMS/*/CSOSN").text
      elsif cst?(xml)
        value += xml.css("ICMS/*/CST").text
      end

      value
    end

    private
    def self.origin(xml)
      xml.css('ICMS/*/orig').text
    end

    def self.cst?(xml)
      xml.css("ICMS/*/CST").text != ""
    end

    def self.csosn?(xml)
      xml.css("ICMS/*/CSOSN").text != ""
    end
  end
end
