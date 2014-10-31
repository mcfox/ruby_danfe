module RubyDanfe
  class Helper
    def self.numerify(number, decimals = 2)
      number = number.tr("\n","").delete(" ")
      return "" if !number || number == ""
      int, frac = ("%.#{decimals}f" % number).split(".")
      int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1\.")
      int + "," + frac
      rescue
        number
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

    def self.format_datetime(string)
      formated_datetime = ""

      if not string.empty?
        date = DateTime.strptime(string, "%Y-%m-%dT%H:%M:%S")
        formated_datetime = date.strftime("%d/%m/%Y %H:%M:%S")
      end

      formated_datetime
    end

    def self.format_date(string)
      formated_date = ""

      if not string.empty?
        date = Date.strptime(string, "%Y-%m-%d")
        formated_date = date.strftime("%d/%m/%Y")
      end

      formated_date
    end

    def self.format_time(string)
      formated_time = ""

      if not string.empty?
        time = Time.new(string)
        formated_time = time.strftime("%H:%M:%S")
      end

      formated_time
    end

    def self.extract_time_from_date(string)
      formated_time = ""

      if not string.empty?
        date = DateTime.strptime(string, "%Y-%m-%dT%H:%M:%S")
        formated_time = date.strftime("%H:%M:%S")
      end

      formated_time
    end
  end
end
