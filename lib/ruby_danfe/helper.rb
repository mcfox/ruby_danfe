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

    def self.numerify_default_zero(number, decimals = 2)
      number = number.tr("\n","").delete(" ")
      return "0,00" if !number || number == ""
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
        date = extract_date_time(string)
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
        time = Time.strptime(string, "%H:%M:%S")
        formated_time = time.strftime("%H:%M:%S")
      end

      formated_time
    end

    def self.extract_time_from_date(string)
      formated_time = ""

      if not string.empty?
        date = extract_date_time(string)
        formated_time = date.strftime("%H:%M:%S")
      end

      formated_time
    end

    def self.format_cpf(string)
      formated_cpf = ""

      if not (string.empty? || string.size != 11)
        formated_cpf = string[0,3] + '.' + string[3,3] + '.' + string[6,3] + '-' + string[9,2]
      end

      formated_cpf
    end

    def self.format_cnpj(string)
      formated_cnpj = ""

      if not (string.empty? || string.size != 14)
        formated_cnpj = string[0,2] + '.' + string[2,3] + '.' + string[5,3] +
                        '/' + string[8,4] + '-' + string[12,2]
      end

      formated_cnpj
    end

    def self.format_fone(string)
      formated_fone = ""

      unless string.eql?('')
        if string.size > 8
          formated_fone = "("+ string[0,2] + ") " + string[2,4] + '-' + string[6,4]
        else
          formated_fone = string[0,4] + "-" + string[4,4]
        end
      end

      formated_fone
    end

    def self.format_car_plate(string)
      formated_car_plate = ""

      formated_car_plate = string[0,3] + "-" + string[3,6] if !string.eql?('')
    end

    private

    def self.extract_date_time(string)
      begin
        DateTime.strptime(string, "%Y-%m-%dT%H:%M:%S")
      rescue ArgumentError
        DateTime.strptime(string, "%d/%m/%Y %H:%M:%S")
      end
    end
  end
end
