#encoding: utf-8

require "spec_helper"

describe RubyDanfe::Descricao do
  LINEBREAK = "\n"

  let(:xml_fci) do
    xml = <<-eos
    <det nItem="1">
      <prod>
        <xProd>MONITOR DE ARCO ELETRICO</xProd>
        <nFCI>12232531-74B2-4FDD-87A6-CF0AD3E55386</nFCI>
      </prod>
    </det>
    eos

    Nokogiri::XML(xml)
  end

  let(:xml_st) do
    xml = <<-eos
    <det nItem="1">
      <prod>
        <xProd>MONITOR DE ARCO ELETRICO</xProd>
      </prod>
      <imposto>
        <vTotTrib>96.73</vTotTrib>
        <ICMS>
          <ICMSSN202>
            <pMVAST>56.00</pMVAST>
            <vBCST>479.82</vBCST>
            <pICMSST>17.00</pICMSST>
            <vICMSST>29.28</vICMSST>
          </ICMSSN202>
        </ICMS>
      </imposto>
    </det>
    eos

    Nokogiri::XML(xml)
  end

  let(:xml_infAdProd) do
    xml = <<-eos
    <det nItem="1">
      <prod>
        <xProd>MONITOR DE ARCO ELETRICO</xProd>
      </prod>
      <infAdProd>Informações adicionais do produto</infAdProd>
    </det>
    eos

    Nokogiri::XML(xml)
  end

  let(:xml_veicProd) do
    xml = <<-eos
    <det nItem="1">
      <prod>
        <xProd>MOTOCICLETA</xProd>
        <veicProd>
          <chassi>32A1SF354S6FASD213ASD5</chassi>
          <xCor>PRETA</xCor>
          <nMotor>DSA5DA-321503</nMotor>
          <anoMod>2018</anoMod>
          <anoFab>2018</anoFab>
        </veicProd>
      </prod>
    </det>
    eos

    Nokogiri::XML(xml)
  end

  let(:xml_IFC_ST_infAdProd) do
    xml = <<-eos
    <det nItem="1">
      <prod>
        <xProd>MONITOR DE ARCO ELETRICO</xProd>
        <nFCI>12232531-74B2-4FDD-87A6-CF0AD3E55386</nFCI>
      </prod>
      <imposto>
        <vTotTrib>96.73</vTotTrib>
        <ICMS>
          <ICMSSN202>
            <pMVAST>56.00</pMVAST>
            <vBCST>479.82</vBCST>
            <pICMSST>17.00</pICMSST>
            <vICMSST>29.28</vICMSST>
          </ICMSSN202>
        </ICMS>
      </imposto>
      <infAdProd>Informações adicionais do produto</infAdProd>
    </det>
    eos

    Nokogiri::XML(xml)
  end

  describe ".generate" do
    context "when have FCI" do
      it "returns product + FCI" do
        string = "MONITOR DE ARCO ELETRICO"
        string += LINEBREAK
        string +="FCI: 12232531-74B2-4FDD-87A6-CF0AD3E55386"
        expect(RubyDanfe::Descricao.generate(xml_fci)).to eq string
      end
    end

    context "when have ST" do
      it "returns product + ST" do
        string = "MONITOR DE ARCO ELETRICO"
        string += LINEBREAK
        string += "ST: MVA: 56.00% "
        string += "* Alíq: 17.00% "
        string += "* BC: 479.82 "
        string += "* Vlr: 29.28"
        expect(RubyDanfe::Descricao.generate(xml_st)).to eq string
      end
    end

    context "when have infAdProd" do
      it "returns product + infAdProd" do
        string = "MONITOR DE ARCO ELETRICO"
        string += LINEBREAK
        string += "Informações adicionais do produto"
        expect(RubyDanfe::Descricao.generate(xml_infAdProd)).to eq string
      end
    end

    context "when have veicProd" do
      it "returns product + veicProd" do
        string = "MOTOCICLETA"
        string += LINEBREAK
        string += "Chassi: 32A1SF354S6FASD213ASD5 "
        string += "Motor: DSA5DA-321503 "
        string += "AnoFab: 2018 "
        string += "AnoMod: 2018 "
        string += "Cor: PRETA"
        expect(RubyDanfe::Descricao.generate(xml_veicProd)).to eq string        
      end
    end

    context "when have FCI + ST + infAdProd" do
      it "returns product + FCI + ST + infAdProd" do
        string = "MONITOR DE ARCO ELETRICO"
        string += LINEBREAK
        string += "Informações adicionais do produto"
        string += LINEBREAK
        string +="FCI: 12232531-74B2-4FDD-87A6-CF0AD3E55386"
        string += LINEBREAK
        string += "ST: MVA: 56.00% "
        string += "* Alíq: 17.00% "
        string += "* BC: 479.82 "
        string += "* Vlr: 29.28"
        expect(RubyDanfe::Descricao.generate(xml_IFC_ST_infAdProd)).to eq string
      end
    end
  end
end
