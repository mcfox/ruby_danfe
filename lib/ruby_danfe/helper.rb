module RubyDanfe
  class Helper
    def self.numerify(number, decimals = 2)
      return "" if !number || number == ""
      int, frac = ("%.#{decimals}f" % number).split(".")
      int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1\.")
      int + "," + frac
    end

    def self.invert(y)
      28.7.cm - y
    end

    def self.format_date(string)
      formated_date = ""

      if not string.empty?
        date = DateTime.strptime(string, "%Y-%m-%dT%H:%M:%S")
        formated_date = date.strftime("%d/%m/%Y %H:%M:%S")
      end

      formated_date
    end
    
    def self.without_fiscal_value?(xml)
      homologation?(xml) || unauthorized?(xml)
    end

    private
    def self.homologation?(xml)
      xml.css("nfeProc/NFe/infNFe/ide/tpAmb").text == "2"
    end

    def self.unauthorized?(xml)
      xml.css("nfeProc/protNFe/infProt/dhRecbto").empty?
    end
  end
end
