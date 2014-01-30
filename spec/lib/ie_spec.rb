require "spec_helper"

describe RubyDanfe::Ie do
  describe ".format" do
    context "when UF is AC" do
      it "returns a formated ie" do
        ie = "1234567890123"
        expect(RubyDanfe::Ie.format(ie, "AC")).to eq "12.345.678/901-23"
      end
    end

    context "when UF is AL" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "AL")).to eq "123456789"
      end
    end

    context "when UF is AP" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "AP")).to eq "123456789"
      end
    end

    context "when UF is AM" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "AM")).to eq "12.345.678-9"
      end
    end

    context "when UF is BA" do
      context "when IE have 8 digits" do
        it "returns a formated ie" do
          ie = "12345678"
          expect(RubyDanfe::Ie.format(ie, "BA")).to eq "123456-78"
        end
      end

      context "when IE have 9 digits" do
        it "returns a formated ie" do
          ie = "123456789"
          expect(RubyDanfe::Ie.format(ie, "BA")).to eq "1234567-89"
        end
      end
    end

    context "when UF is CE" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "CE")).to eq "12345678-9"
      end
    end

    context "when UF is DF" do
      it "returns a formated ie" do
        ie = "1234567890123"
        expect(RubyDanfe::Ie.format(ie, "DF")).to eq "12345678901-23"
      end
    end

    context "when UF is ES" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "ES")).to eq "123456789"
      end
    end

    context "when UF is GO" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "GO")).to eq "12.345.678-9"
      end
    end

    context "when UF is MA" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "MA")).to eq "123456789"
      end
    end

    context "when UF is MT" do
      it "returns a formated ie" do
        ie = "12345678901"
        expect(RubyDanfe::Ie.format(ie, "MT")).to eq "1234567890-1"
      end
    end

    context "when UF is MS" do
      it "returns a formated ie" do
        ie = "12345678"
        expect(RubyDanfe::Ie.format(ie, "MS")).to eq "12345678"
      end
    end

    context "when UF is MG" do
      it "returns a formated ie" do
        ie = "1234567890123"
        expect(RubyDanfe::Ie.format(ie, "MG")).to eq "123.456.789/0123"
      end
    end

    context "when UF is PA" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "PA")).to eq "12-345678-9"
      end
    end

    context "when UF is PB" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "PB")).to eq "12345678-9"
      end
    end

    context "when UF is PR" do
      it "returns a formated ie" do
        ie = "1234567890"
        expect(RubyDanfe::Ie.format(ie, "PR")).to eq "12345678-90"
      end
    end

    context "when UF is PE" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "PE")).to eq "1234567-89"
      end
    end

    context "when UF is PI" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "PI")).to eq "123456789"
      end
    end

    context "when UF is RJ" do
      it "returns a formated ie" do
        ie = "12345678"
        expect(RubyDanfe::Ie.format(ie, "RJ")).to eq "12.345.67-8"
      end
    end

    context "when UF is RN" do
      context "when IE have 9 digits" do
        it "returns a formated ie" do
          ie = "123456789"
          expect(RubyDanfe::Ie.format(ie, "RN")).to eq "12.345.678-9"
        end
      end

      context "when IE have 10 digits" do
        it "eturns a formated ie" do
          ie = "1234567890"
          expect(RubyDanfe::Ie.format(ie, "RN")).to eq "12.3.456.789-0"
        end
      end
    end

    context "when UF is RS" do
      it "returns a formated ie" do
        ie = "1234567890"
        expect(RubyDanfe::Ie.format(ie, "RS")).to eq "123/4567890"
      end
    end

    context "when UF is RO" do
      context "when IE have 9 digits" do
        it "returns a formated ie" do
          ie = "123456789"
          expect(RubyDanfe::Ie.format(ie, "RO")).to eq "123.45678-9"
        end
      end

      context "when IE have 14 digits" do
        it "returns a formated ie" do
          ie = "12345678901234"
          expect(RubyDanfe::Ie.format(ie, "RO")).to eq "1234567890123-4"
        end
      end
    end

    context "when UF is RR" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "RR")).to eq "12345678-9"
      end
    end

    context "when UF is SC" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "SC")).to eq "123.456.789"
      end
    end

    context "when UF is SP" do
      context "when IE have 12 digits" do
        it "returns a formated ie" do
          ie = "123456789012"
          expect(RubyDanfe::Ie.format(ie, "SP")).to eq "123.456.789.012"
        end
      end

      context "when IE have 13 digits" do
        it "returns a formated ie" do
          ie = "A123456789012"
          expect(RubyDanfe::Ie.format(ie, "SP")).to eq "A-12345678.9/012"
        end
      end
    end

    context "when UF is SE" do
      it "returns a formated ie" do
        ie = "123456789"
        expect(RubyDanfe::Ie.format(ie, "SE")).to eq "12345678-9"
      end
    end

    context "when UF is TO" do
      it "returns a formated ie" do
        ie = "12345678901"
        expect(RubyDanfe::Ie.format(ie, "TO")).to eq "12345678901"
      end
    end
  end
end
