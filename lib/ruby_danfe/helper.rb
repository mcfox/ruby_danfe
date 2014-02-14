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

    def self.format_quantity(qty)
      return Helper.numerify(qty, RubyDanfe.options.quantity_decimals) if RubyDanfe.options.numerify_prod_qcom
      qty.gsub!(",", ".")
      qty[qty.rindex('.')] = ',' if qty.rindex('.')
      qty
    end

    def self.format_date(string)
      formated_date = ""

      if not string.empty?
        date = DateTime.strptime(string, "%Y-%m-%dT%H:%M:%S")
        formated_date = date.strftime("%d/%m/%Y %H:%M:%S")
      end

      formated_date
    end
  end
end
