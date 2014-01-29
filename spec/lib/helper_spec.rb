require "spec_helper"

describe RubyDanfe::Helper do
  describe ".format_date" do
    it "returns a formated string" do
      string = "2013-10-18T13:54:04"
      expect(RubyDanfe::Helper.format_date(string)).to eq "18/10/2013 13:54:04"
    end
  end

  describe ".without_fiscal_value?" do
    let(:xml_homologation) do
      xml = <<-eos
        <nfeProc>
          <NFe>
            <infNFe>
              <ide>
                <tpAmb>2</tpAmb>
              </ide>
            </infNFe>
            <protNFe>
              <infProt>
                <dhRecbto>2011-10-29T14:37:09</dhRecbto>
              </infProt>
            </protNFe>
          </NFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    let(:xml_unauthorized) do
      xml = <<-eos
        <nfeProc>
          <protNFe>
            <infProt></infProt>
          </protNFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    let(:xml_authorized) do
      xml = <<-eos
        <nfeProc>
          <NFe>
            <infNFe>
              <ide>
                <tpAmb>1</tpAmb>
              </ide>
            </infNFe>
          </NFe>
          <protNFe>
            <infProt>
              <dhRecbto>2011-10-29T14:37:09</dhRecbto>
            </infProt>
          </protNFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    context "when XML is unauthorized" do
      it "returns true" do
        expect(RubyDanfe::Helper.without_fiscal_value?(xml_unauthorized)).to eq true
      end
    end

    context "when XML is in homologation environment" do
      it "returns true" do
        expect(RubyDanfe::Helper.without_fiscal_value?(xml_homologation)).to eq true
      end
    end

    context "when XML is authorized" do
      it "returns false" do
        expect(RubyDanfe::Helper.without_fiscal_value?(xml_authorized)).to eq false
      end
    end
  end
end
