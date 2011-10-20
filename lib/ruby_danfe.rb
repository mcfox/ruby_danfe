require 'rubygems'
require 'prawn'
require 'nokogiri'

module RubyDanfe

  version = "0.0.2"

  class XML
    def initialize(xml_filename)
      @xml = Nokogiri::XML(File.new(xml_filename))  
    end
    def [](xpath)
      node = @xml.css(xpath)
      return node ? node.text : ''
    end
  end
    
  def self.generate(pdf_filename, xml_filename)
  
    xml = XML.new(xml_filename)

    Prawn::Document.generate(pdf_filename) do |pdf|

      # rectangle
      pdf.stroke_rectangle [328, 653], 222, 22

      # rectangle
      pdf.stroke_rectangle [328, 697], 222, 84

      # rectangle
      pdf.stroke_rectangle [347, 457], 96, 18

      # rectangle
      pdf.stroke_rectangle [443, 749], 107, 37

      # rectangle
      pdf.stroke_rectangle [112, 526], 63, 44

      # rectangle
      pdf.stroke_rectangle [49, 526], 63, 44

      # rectangle
      pdf.stroke_rectangle [-14, 526], 63, 44

      # rectangle
      pdf.stroke_rectangle [429, 431], 24, 18

      # rectangle
      pdf.stroke_rectangle [165, 431], 59, 18

      # rectangle
      pdf.stroke_rectangle [213, 424], 9, 9

      # rectangle
      pdf.stroke_rectangle [364, 613], 186, 18

      # rectangle
      pdf.stroke_rectangle [175, 613], 189, 18

      # rectangle
      pdf.stroke_rectangle [328, 673], 222, 18

      # rectangle
      pdf.stroke_rectangle [328, 697], 222, 24

      # rectangle
      pdf.stroke_rectangle [264, 697], 64, 66

      # rectangle
      pdf.stroke_rectangle [312, 668], 9, 10

      # rectangle
      pdf.stroke_rectangle [-14, 431], 179, 18

      # rectangle
      pdf.stroke_rectangle [-14, 475], 134, 18

      # rectangle
      pdf.stroke_rectangle [-14, 457], 91, 18

      # rectangle
      pdf.stroke_rectangle [-14, 587], 373, 20

      # rectangle
      pdf.stroke_rectangle [224, 431], 75, 18

      # rectangle
      pdf.stroke_rectangle [119, 475], 115, 18

      # rectangle
      pdf.stroke_rectangle [233, 475], 115, 18

      # rectangle
      pdf.stroke_rectangle [347, 475], 97, 18

      # rectangle
      pdf.stroke_rectangle [443, 475], 107, 18

      # rectangle
      pdf.stroke_rectangle [-14, 568], 305, 18

      # rectangle
      pdf.stroke_rectangle [471, 587], 79, 20

      # rectangle
      pdf.stroke_rectangle [358, 587], 113, 20

      # rectangle
      pdf.stroke_rectangle [290, 568], 125, 18

      # rectangle
      pdf.stroke_rectangle [414, 568], 57, 18

      # rectangle
      pdf.stroke_rectangle [213, 551], 111, 18

      # rectangle
      pdf.stroke_rectangle [323, 551], 32, 18

      # rectangle
      pdf.stroke_rectangle [471, 568], 79, 18

      # rectangle
      pdf.stroke_rectangle [471, 551], 79, 18

      # rectangle
      pdf.stroke_rectangle [354, 551], 117, 18

      # rectangle
      pdf.stroke_rectangle [-14, 551], 228, 18

      # rectangle
      pdf.stroke_rectangle [255, 457], 92, 18

      # rectangle
      pdf.stroke_rectangle [76, 457], 90, 18

      # rectangle
      pdf.stroke_rectangle [165, 457], 90, 18

      # rectangle
      pdf.stroke_rectangle [443, 457], 107, 18

      # rectangle
      pdf.stroke_rectangle [298, 431], 131, 18

      # rectangle
      pdf.stroke_rectangle [245, 413], 185, 18

      # rectangle
      pdf.stroke_rectangle [453, 431], 97, 18

      # rectangle
      pdf.stroke_rectangle [-14, 413], 260, 18

      # rectangle
      pdf.stroke_rectangle [-14, 395], 67, 18

      # rectangle
      pdf.stroke_rectangle [53, 395], 117, 18

      # rectangle
      pdf.stroke_rectangle [170, 395], 107, 18

      # rectangle
      pdf.stroke_rectangle [277, 395], 109, 18

      # rectangle
      pdf.stroke_rectangle [429, 413], 24, 18

      # rectangle
      pdf.stroke_rectangle [453, 413], 97, 18

      # rectangle
      pdf.stroke_rectangle [386, 395], 81, 18

      # rectangle
      pdf.stroke_rectangle [467, 395], 83, 18

      # rectangle
      pdf.stroke_rectangle [-14, 631], 342, 18

      # rectangle
      pdf.stroke_rectangle [-14, 613], 189, 18

      # rectangle
      pdf.stroke_rectangle [-14, 749], 457, 20

      # rectangle
      pdf.stroke_rectangle [-14, 729], 74, 17

      # rectangle
      pdf.stroke_rectangle [60, 729], 383, 17

      # rectangle
      pdf.stroke_rectangle [175, 526], 63, 44

      # rectangle
      pdf.stroke_rectangle [238, 526], 63, 44

      # rectangle
      pdf.stroke_rectangle [301, 526], 63, 44

      # rectangle
      pdf.stroke_rectangle [364, 526], 63, 44

      # rectangle
      pdf.stroke_rectangle [427, 526], 63, 44

      # rectangle
      pdf.stroke_rectangle [490, 526], 60, 44

      # rectangle
      pdf.stroke_rectangle [-14, 367], 564, 213

      # rectangle
      pdf.stroke_rectangle [-14, 117], 341, 173

      # rectangle
      pdf.stroke_rectangle [327, 117], 223, 173

      # rectangle
      pdf.stroke_rectangle [-14, 146], 112, 20

      # rectangle
      pdf.stroke_rectangle [97, 146], 145, 20

      # rectangle
      pdf.stroke_rectangle [241, 146], 145, 20

      # rectangle
      pdf.stroke_rectangle [385, 146], 165, 20

      # staticText
      pdf.draw_text "PROTOCOLO DE AUTORIZAÇÃO DE USO", :size => 5, :at => [332, 626], :width => 142, :height => 7

      # textField xml['infProt/nProt'] + ' ' + xml['infProt/dhRecbto']
      pdf.draw_text xml['infProt/nProt'] + ' ' + xml['infProt/dhRecbto'], :size => 6, :at => [333, 617], :width => 215, :height => 9

      # staticText
      pdf.draw_text "Consulta de autenticidade no portal nacional da NF-e www.nfe.fazenda.gov.br/portal ou no site da Sefaz Autorizadora", :size => 6, :at => [330, 638], :width => 218, :height => 17

      # staticText
      pdf.draw_text "N°.", :size => 7, :at => [446, 728], :width => 9, :height => 9

      # staticText
      pdf.draw_text "DESTINATÁRIO / REMETENTE", :size => 5, :at => [-14, 591], :width => 109, :height => 8

      # staticText
      pdf.draw_text "CNPJ/CPF", :size => 5, :at => [361, 582], :width => 46, :height => 7

      # staticText
      pdf.draw_text "DATA DA EMISSÃO", :size => 5, :at => [474, 582], :width => 49, :height => 7

      # staticText
      pdf.draw_text "NOME/RAZÃO SOCIAL", :size => 5, :at => [-11, 582], :width => 107, :height => 7

      # staticText
      pdf.draw_text "ENDEREÇO", :size => 5, :at => [-11, 563], :width => 107, :height => 7

      # staticText
      pdf.draw_text "BAIRRO / DISTRITO", :size => 5, :at => [293, 563], :width => 69, :height => 7

      # staticText
      pdf.draw_text "CEP", :size => 5, :at => [415, 563], :width => 30, :height => 7

      # staticText
      pdf.draw_text "FONE/FAX", :size => 5, :at => [217, 546], :width => 49, :height => 7

      # staticText
      pdf.draw_text "UF", :size => 5, :at => [326, 546], :width => 17, :height => 7

      # staticText
      pdf.draw_text "FATURA / DUPLICATAS", :size => 5, :at => [-14, 530], :width => 109, :height => 7

      # staticText
      pdf.draw_text "CÁLCULO DO IMPOSTO", :size => 5, :at => [-14, 479], :width => 109, :height => 7

      # staticText
      pdf.draw_text "BASE DE CÁLCULO DO ICMS", :size => 5, :at => [-11, 470], :width => 73, :height => 7

      # staticText
      pdf.draw_text "VALOR DO ICMS", :size => 5, :at => [122, 470], :width => 78, :height => 7

      # staticText
      pdf.draw_text "BASE DE CÁLCULO DO ICMS ST", :size => 5, :at => [236, 470], :width => 80, :height => 7

      # staticText
      pdf.draw_text "VALOR DO ICMS ST", :size => 5, :at => [350, 470], :width => 59, :height => 7

      # staticText
      pdf.draw_text "VALOR TOTAL DOS PRODUTOS", :size => 5, :at => [446, 470], :width => 79, :height => 7

      # staticText
      pdf.draw_text "TRANSPORTADOR / VOLUMES TRANSPORTADOS DADOS DO PRODUTO / SERVIÇODADOS DO PRODUTO / SERVIÇODADOS DO PRODUTO / SERVIÇO", :size => 5, :at => [-14, 435], :width => 134, :height => 8

      # staticText
      pdf.draw_text "RAZÃO SOCIAL", :size => 5, :at => [-11, 426], :width => 64, :height => 7

      # staticText
      pdf.draw_text "FRETE POR CONTA", :size => 5, :at => [167, 426], :width => 49, :height => 7

      # staticText
      pdf.draw_text "CÓDIGO ANTT", :size => 5, :at => [227, 426], :width => 49, :height => 7

      # staticText
      pdf.draw_text "0-EMITENTE 1-DESTINATÁRIO", :size => 4, :at => [167, 416], :width => 44, :height => 12

      # textField dest/xNome
      pdf.draw_text xml['dest/xNome'], :size => 7, :at => [-11, 572], :width => 366, :height => 9

      # textField enderDest/xLgr enderDest/nro
      pdf.draw_text xml['enderDest/xLgr'] + " " + xml['enderDest/nro'], :size => 7, :at => [-11, 555], :width => 298, :height => 9

      # textField dest/CNPJ
      pdf.draw_text xml['dest/CNPJ'], :size => 7, :at => [361, 572], :width => 107, :height => 9

      # textField ide/dEmi
      pdf.draw_text xml['ide/dEmi'], :size => 7, :at => [474, 572], :width => 74, :height => 9

      # textField enderDest/xBairro
      pdf.draw_text xml['enderDest/xBairro'], :size => 7, :at => [293, 555], :width => 119, :height => 9

      # textField enderDest/CEP
      pdf.draw_text xml['enderDest/CEP'], :size => 7, :at => [415, 555], :width => 55, :height => 9

      # textField enderDest/UF
      pdf.draw_text xml['enderDest/UF'], :size => 7, :at => [326, 537], :width => 26, :height => 9

      # textField enderDest/fone
      pdf.draw_text xml['enderDest/fone'], :size => 7, :at => [217, 537], :width => 104, :height => 9

      # textField total/vBC
      pdf.draw_text xml['total/vBC'], :size => 7, :at => [-11, 461], :width => 127, :height => 9

      # textField total/vICMS
      pdf.draw_text xml['total/vICMS'], :size => 7, :at => [122, 461], :width => 108, :height => 9

      # textField total/vBCST
      pdf.draw_text xml['total/vBCST'], :size => 7, :at => [236, 461], :width => 108, :height => 9

      # textField total/vST
      pdf.draw_text xml['total/vST'], :size => 7, :at => [350, 461], :width => 90, :height => 9

      # textField total/vProd
      pdf.draw_text xml['total/vProd'], :size => 7, :at => [446, 461], :width => 101, :height => 9

      # textField transporta/xNome
      pdf.draw_text xml['transporta/xNome'], :size => 7, :at => [-11, 417], :width => 174, :height => 9

      # textField transp/modFrete
      pdf.draw_text xml['transp/modFrete'], :size => 5, :at => [214, 420], :width => 7, :height => 7

      # textField veicTransp/RNTC
      pdf.draw_text xml['veicTransp/RNTC'], :size => 5, :at => [227, 417], :width => 69, :height => 9

      # staticText DATA DA SAÍDA/ENTRADA
      pdf.draw_text "DATA DA SAÍDA/ENTRADA", :size => 5, :at => [474, 563], :width => 69, :height => 7

      # staticText HORA DE SAÍDA
      pdf.draw_text "HORA DE SAÍDA", :size => 5, :at => [474, 546], :width => 53, :height => 7

      # staticText INSCRIÇÃO ESTADUAL
      pdf.draw_text "INSCRIÇÃO ESTADUAL", :size => 5, :at => [357, 546], :width => 79, :height => 7

      # textField $F{NR_IE_DESTINO}
      pdf.draw_text xml['dest/IE'], :size => 7, :at => [357, 537], :width => 111, :height => 9

      # textField $F{DS_MUNICIPIO_DESTINO}
      pdf.draw_text xml['enderDest/xMun'], :size => 7, :at => [-11, 537], :width => 222, :height => 9

      # staticText MUNICÍPIO
      pdf.draw_text "MUNICÍPIO", :size => 5, :at => [-11, 546], :width => 107, :height => 7

      # staticText Número
      pdf.draw_text "Número", :size => 5, :at => [-11, 522], :width => 57, :height => 7

      # staticText Vencimento
      pdf.draw_text "Vencimento", :size => 5, :at => [53, 522], :width => 56, :height => 7

      # staticText Valor
      pdf.draw_text "Valor", :size => 5, :at => [116, 522], :width => 55, :height => 7

      # textField $F{VL_OUTROS}
      pdf.draw_text xml['total/vOutros'], :size => 7, :at => [258, 443], :width => 86, :height => 9

      # staticText OUTRAS DESPESAS ACESSÓRIAS
      pdf.draw_text "OUTRAS DESPESAS ACESSÓRIAS", :size => 5, :at => [258, 452], :width => 84, :height => 7

      # textField $F{VL_SEGURO}
      pdf.draw_text xml['total/vSeg'], :size => 7, :at => [79, 443], :width => 83, :height => 9

      # staticText VALOR DO SEGURO
      pdf.draw_text "VALOR DO SEGURO", :size => 5, :at => [79, 452], :width => 59, :height => 7

      # staticText DESCONTO
      pdf.draw_text "DESCONTO", :size => 5, :at => [168, 452], :width => 35, :height => 7

      # textField $F{VL_DESCONTO}
      pdf.draw_text xml['total/vDesc'], :size => 7, :at => [168, 443], :width => 85, :height => 9

      # staticText VALOR DO FRETE
      pdf.draw_text "VALOR DO FRETE", :size => 5, :at => [-11, 452], :width => 50, :height => 7

      # textField $F{VL_FRETE}
      pdf.draw_text xml['total/vlFrete'], :size => 7, :at => [-11, 443], :width => 84, :height => 9

      # textField $F{VL_NF}
      pdf.draw_text xml['total/vNF'], :size => 7, :at => [447, 443], :width => 99, :height => 9

      # staticText VALOR TOTAL DA NOTA
      pdf.draw_text "VALOR TOTAL DA NOTA", :size => 5, :at => [447, 452], :width => 61, :height => 7

      # staticText PLACA DO VEÍCULO
      pdf.draw_text "PLACA DO VEÍCULO", :size => 5, :at => [301, 426], :width => 69, :height => 7

      # staticText CNPJ / CPF
      pdf.draw_text "CNPJ / CPF", :size => 5, :at => [455, 426], :width => 69, :height => 7

      # textField transporta/CNPJ
      pdf.draw_text xml['transporta/CNPJ'], :size => 7, :at => [455, 417], :width => 92, :height => 9

      # textField transporta/xMun
      pdf.draw_text xml['transporta/xMun'], :size => 7, :at => [249, 399], :width => 177, :height => 10

      # staticText
      pdf.draw_text "MUNICÍPIO", :size => 5, :at => [249, 408], :width => 64, :height => 7

      # textField transporta/xEnder
      pdf.draw_text xml['transporta/xEnder'], :size => 7, :at => [-11, 399], :width => 255, :height => 9

      # staticText
      pdf.draw_text "ENDEREÇO", :size => 5, :at => [-11, 408], :width => 64, :height => 7

      # staticText
      pdf.draw_text "QUANTIDADE", :size => 5, :at => [-11, 390], :width => 39, :height => 7

      # textField vol/qVol
      pdf.draw_text xml['vol/qVol'], :size => 7, :at => [-11, 381], :width => 60, :height => 9

      # textField vol/esp
      pdf.draw_text xml['vol/esp'], :size => 7, :at => [56, 381], :width => 111, :height => 9

      # staticText
      pdf.draw_text "ESPÉCIE", :size => 5, :at => [56, 390], :width => 29, :height => 7

      # staticText
      pdf.draw_text "MARCA", :size => 5, :at => [173, 390], :width => 62, :height => 7

      # textField vol/marca
      pdf.draw_text xml['vol/marca'], :size => 7, :at => [173, 381], :width => 97, :height => 9

      # staticText
      pdf.draw_text "NUMERAÇÃO", :size => 5, :at => [280, 390], :width => 62, :height => 7

      # textField
      pdf.draw_text "", :size => 7, :at => [280, 381], :width => 103, :height => 9

      # staticText UF
      pdf.draw_text "UF", :size => 5, :at => [432, 408], :width => 14, :height => 7

      # textField tranporta/UF
      pdf.draw_text xml['tranporta/UF'], :size => 7, :at => [432, 399], :width => 19, :height => 9

      # textField transporta/IE
      pdf.draw_text xml['transporta/IE'], :size => 7, :at => [456, 399], :width => 91, :height => 9

      # staticText
      pdf.draw_text "INSCRIÇÃO ESTADUAL", :size => 5, :at => [456, 408], :width => 69, :height => 7

      # staticText
      pdf.draw_text "PESO BRUTO", :size => 5, :at => [389, 390], :width => 76, :height => 7

      # textField vol/pesoB
      pdf.draw_text xml['vol/pesoB'], :size => 7, :at => [389, 381], :width => 76, :height => 9

      # textField 'vol/pesoL'
      pdf.draw_text xml['vol/pesoL'], :size => 7, :at => [470, 381], :width => 77, :height => 9

      # staticText
      pdf.draw_text "PESO LÍQUIDO", :size => 5, :at => [470, 390], :width => 76, :height => 7

      # textField transp/pĺaca
      pdf.draw_text xml['transp/pĺaca'], :size => 7, :at => [301, 417], :width => 125, :height => 9

      # staticText UF
      pdf.draw_text "UF", :size => 5, :at => [432, 426], :width => 8, :height => 7

      # textField transp/UF
      pdf.draw_text xml['transp/UF'], :size => 7, :at => [432, 417], :width => 18, :height => 9

      # staticText
      pdf.draw_text "VALOR DO IPI", :size => 5, :at => [350, 452], :width => 43, :height => 7

      # textField total/vIPI
      pdf.draw_text xml['total/vIPI'], :size => 7, :at => [350, 443], :width => 90, :height => 9

      # staticText
      pdf.draw_text "DANFE", :size => 10, :at => [267, 689], :width => 58, :height => 12

      # staticText
      pdf.draw_text "DOCUMENTO AUXILIAR DA NOTA FISCAL ELETRÔNICA", :size => 5, :at => [266, 675], :width => 60, :height => 17

      # staticText
      pdf.draw_text "0 - ENTRADA 1 - SAÍDA", :size => 5, :at => [272, 659], :width => 34, :height => 14

      # staticText
      pdf.draw_text "NATUREZA DA OPERAÇÃO", :size => 5, :at => [-11, 626], :width => 107, :height => 7

      # staticText
      pdf.draw_text "INSCRIÇÃO ESTADUAL", :size => 5, :at => [-11, 608], :width => 69, :height => 7

      # staticText
      pdf.draw_text "INSC.ESTADUAL DO SUBST. TRIBUTÁRIO", :size => 5, :at => [178, 608], :width => 107, :height => 7

      # staticText
      pdf.draw_text "CNPJ", :size => 5, :at => [367, 608], :width => 16, :height => 7

      # textField ide/natOp
      pdf.draw_text xml['ide/natOp'], :size => 7, :at => [-11, 617], :width => 336, :height => 9

      # textField emit/IE
      pdf.draw_text xml['emit/IE'], :size => 7, :at => [-11, 599], :width => 183, :height => 9

      # textField emit/IE_ST
      pdf.draw_text xml['emit/IE_ST'], :size => 7, :at => [178, 599], :width => 183, :height => 9

      # textField emit/CNPJ
      pdf.draw_text xml['emit/CNPJ'], :size => 7, :at => [367, 599], :width => 181, :height => 9

      # textField ide/dSaiEnt
      pdf.draw_text xml['ide/dSaiEnt'], :size => 5, :at => [314, 664], :width => 5, :height => 6

      # textField ide/serie
      pdf.draw_text xml['ide/serie'], :size => 6, :at => [287, 643], :width => 38, :height => 7

      # staticText 
      pdf.draw_text "SÉRIE", :size => 6, :at => [268, 643], :width => 19, :height => 7

      # textField ide/nNF
      pdf.draw_text xml['ide/nNF'], :size => 7, :at => [277, 650], :width => 48, :height => 9

      # staticText
      pdf.draw_text "DATA DE RECEBIMENTO", :size => 5, :at => [-11, 724], :width => 65, :height => 7

      # staticText
      pdf.draw_text "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", :size => 5, :at => [63, 724], :width => 259, :height => 7

      # staticText
      pdf.draw_text "NF-e", :size => 9, :at => [446, 738], :width => 102, :height => 12

      # textField ide/serie
      pdf.draw_text xml['ide/serie'], :size => 7, :at => [472, 719], :width => 76, :height => 9

      # textField ide/nNF
      pdf.draw_text xml['ide/nNF'], :size => 7, :at => [455, 728], :width => 93, :height => 9

      # textField
      pdf.draw_text "RECEBEMOS DE " + xml['emit/xNome'] + " OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA A BAIXO", :size => 5, :at => [-11, 744], :width => 450, :height => 8

      # staticText
      pdf.draw_text "SÉRIE", :size => 7, :at => [446, 719], :width => 26, :height => 9

      # staticText
      pdf.draw_text "CHAVE DE ACESSO", :size => 5, :at => [331, 668], :width => 67, :height => 7

      # staticText
      pdf.draw_text "FOLHA", :size => 6, :at => [268, 636], :width => 19, :height => 7

      # textField
      pdf.draw_text " 1 / 1", :size => 6, :at => [287, 636], :width => 9, :height => 7

      # textField chNFe
      pdf.draw_text xml['chNFe'], :size => 6, :at => [331, 659], :width => 217, :height => 9

      # staticText
      pdf.draw_text "DADOS DO PRODUTO / SERVIÇO", :size => 5, :at => [-14, 372], :width => 134, :height => 8

      # staticText
      pdf.draw_text "N°", :size => 7, :at => [268, 650], :width => 10, :height => 9

      # textField emit/xNome
      pdf.draw_text xml['emit/xNome'], :size => 7, :at => [62, 680], :width => 198, :height => 21

      # textField enderEmit/xLgr enderEmit/nro
      pdf.draw_text xml['enderEmit/xLgr'] + ", " + xml['enderEmit/nro'], :size => 7, :at => [62, 669], :width => 198, :height => 10

      # textField enderEmit/xBairro
      pdf.draw_text xml['enderEmit/xBairro'] + " - " + xml['enderEmit/CEP'], :size => 7, :at => [62, 659], :width => 198, :height => 10

      # textField enderEmit/xMun enderEmit/UF
      pdf.draw_text xml['enderEmit/xMun'] + "/" + xml['enderEmit/UF'], :size => 6, :at => [62, 649], :width => 198, :height => 10

      # textField enderEmit/fone enderEmit/email
      pdf.draw_text xml['enderEmit/fone'] + " " + xml['enderEmit/email'], :size => 6, :at => [62, 639], :width => 198, :height => 10

      # textField ide/dSaiEnt
      pdf.draw_text xml['ide/dSaiEnt'], :size => 7, :at => [474, 555], :width => 74, :height => 9

      # textField ide/dSaiEnt
      pdf.draw_text xml['ide/dSaiEnt'], :size => 7, :at => [474, 537], :width => 74, :height => 9

      # staticText
      pdf.draw_text "Número", :size => 5, :at => [178, 522], :width => 57, :height => 7

      # staticText
      pdf.draw_text "Vencimento", :size => 5, :at => [242, 522], :width => 56, :height => 7

      # staticText
      pdf.draw_text "Valor", :size => 5, :at => [305, 522], :width => 55, :height => 7

      # staticText
      pdf.draw_text "Número", :size => 5, :at => [367, 522], :width => 57, :height => 7

      # staticText
      pdf.draw_text "Vencimento", :size => 5, :at => [431, 522], :width => 56, :height => 7

      # staticText
      pdf.draw_text "Valor", :size => 5, :at => [494, 522], :width => 50, :height => 7

      # textField infAdic/infCpl
      pdf.draw_text xml['infAdic/infCpl'], :size => 6, :at => [-10, -50], :width => 334, :height => 161

      # staticText
      pdf.draw_text "DADOS ADICIONAIS", :size => 5, :at => [-14, 121], :width => 134, :height => 7

      # staticText
      pdf.draw_text "CÁLCULO DO ISSQN", :size => 5, :at => [-14, 150], :width => 134, :height => 8

      # staticText
      pdf.draw_text "INSCRIÇÃO MUNICIPAL", :size => 5, :at => [-11, 141], :width => 83, :height => 8

      # staticText
      pdf.draw_text "VALOR TOTAL DOS SERVIÇOS", :size => 5, :at => [100, 141], :width => 103, :height => 8

      # textField total/vServ
      pdf.draw_text xml['total/vServ'], :size => 7, :at => [100, 130], :width => 138, :height => 10

      # textField emit/IM
      pdf.draw_text xml['emit/IM'], :size => 7, :at => [-11, 130], :width => 105, :height => 10

      # staticText 
      pdf.draw_text "BASE DE CÁLCULO DO ISSQN", :size => 5, :at => [244, 141], :width => 103, :height => 8

      # textField total/vBCISS
      pdf.draw_text xml['total/vBCISS'], :size => 7, :at => [244, 130], :width => 138, :height => 10

      # staticText 
      pdf.draw_text "VALOR DO ISSQN", :size => 5, :at => [388, 141], :width => 103, :height => 8

      # textField total/ISSTot
      pdf.draw_text xml['total/ISSTot'], :size => 7, :at => [388, 130], :width => 159, :height => 10

      # textField 
      pdf.draw_text "", :size => 6, :at => [331, -50], :width => 216, :height => 163

      # staticText
      pdf.draw_text "RESERVADO AO FISCO", :size => 5, :at => [331, 113], :width => 96, :height => 7

      # staticText
      pdf.draw_text "INFORMAÇÕES COMPLEMENTARES", :size => 5, :at => [-11, 112], :width => 93, :height => 7

    end
    
  end
  
end
