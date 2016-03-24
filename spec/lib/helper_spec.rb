require "spec_helper"

describe RubyDanfe::Helper do
  describe ".format_datetime" do
    context "when date format is %Y-%m-%d" do      
      it "returns a formated string" do
        string = "2013-10-18T13:54:04"
        expect(RubyDanfe::Helper.format_datetime(string)).to eq "18/10/2013 13:54:04"
      end
    end

    context "when date format is %d/%m/%Y" do      
      it "returns a formated string" do
        string = "25/02/2016  09:22:26"
        expect(RubyDanfe::Helper.format_datetime(string)).to eq "25/02/2016 09:22:26"
      end
    end
  end

  describe ".format_date" do
    it "returns a formated string" do
      string = "2013-10-18"
      expect(RubyDanfe::Helper.format_date(string)).to eq "18/10/2013"
    end

    it "returns a formated string" do
      string = ""
      expect(RubyDanfe::Helper.format_date(string)).to eq ""
    end
  end

  describe ".format_time" do
    it "returns a formated string" do
      string = "22:30:45"
      expect(RubyDanfe::Helper.format_time(string)).to eq "22:30:45"
    end

    it "returns a formated string" do
      string = ""
      expect(RubyDanfe::Helper.format_time(string)).to eq ""
    end
  end

  describe ".format_quantity" do
    context "with RubyDanfe.options.numerify_prod_qcom false" do
      before(:each) {
        RubyDanfe.options.numerify_prod_qcom = false
      }
      it "should replace last dot for comma" do
        expect(RubyDanfe::Helper.format_quantity("100.00")).to eq "100,00"
      end
      it "should replace all commas for dot except the last one" do
        expect(RubyDanfe::Helper.format_quantity("2,100.00")).to eq "2.100,00"
      end
      it "should do anything if there is no comma and dot" do
        expect(RubyDanfe::Helper.format_quantity("100")).to eq "100"
      end
      it "should keep decimals" do
        expect(RubyDanfe::Helper.format_quantity("1.665")).to eq "1,665"
      end
    end

    context "with RubyDanfe.options.numerify_prod_qcom true" do
      context "with quantity_decimals = 4" do
        before(:each) {
          RubyDanfe.options.numerify_prod_qcom = true
          RubyDanfe.options.quantity_decimals = 4
        }
        it "should format number to 4 decimal places" do
          expect(RubyDanfe::Helper.format_quantity("100.00")).to eq "100,0000"
        end
        it "should format number with thousand separator" do
          expect(RubyDanfe::Helper.format_quantity("8956100.00")).to eq "8.956.100,0000"
        end
        it "should format number without dot and comma" do
          expect(RubyDanfe::Helper.format_quantity("200")).to eq "200,0000"
        end
      end

      context "with quantity_decimals = 3" do
        before(:each) {
          RubyDanfe.options.numerify_prod_qcom = true
          RubyDanfe.options.quantity_decimals = 3
        }
        it "should format number to 4 decimal places" do
          expect(RubyDanfe::Helper.format_quantity("100.00")).to eq "100,000"
        end
        it "should format number with thousand separator" do
          expect(RubyDanfe::Helper.format_quantity("8956100.00")).to eq "8.956.100,000"
        end
        it "should format number without dot and comma" do
          expect(RubyDanfe::Helper.format_quantity("200")).to eq "200,000"
        end
      end
    end
  end
end
