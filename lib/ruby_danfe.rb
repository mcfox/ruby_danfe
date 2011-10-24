require 'rubygems'
require 'prawn'
require 'prawn/measurement_extensions'
require 'nokogiri'

module RubyDanfe

  version = "0.0.3"

  class XML
    def initialize(xml)
      @xml = Nokogiri::XML(xml)
    end
    def [](xpath)
      node = @xml.css(xpath)
      return node ? node.text : ''
    end
    def render
      RubyDanfe.render @xml.to_s
    end
  end
  
  def self.generatePDFFromXML(xml)
  
    pdf = Prawn::Document.new(
      :page_size => 'A4',
      :page_layout => :portrait,
      :left_margin => 0.5.cm,
      :right_margin => 0.5.cm,
      :top_margin => 0.5.cm,
      :botton_margin => 0.5.cm
    )

    # rectangle
	pdf.stroke_rectangle [342, 693], 222, 22

    # rectangle
	pdf.stroke_rectangle [342, 737], 222, 84

    # rectangle
	pdf.stroke_rectangle [361, 497], 96, 18

    # rectangle
	pdf.stroke_rectangle [457, 789], 107, 37

    # rectangle
	pdf.stroke_rectangle [126, 566], 63, 44

    # rectangle
	pdf.stroke_rectangle [63, 566], 63, 44

    # rectangle
	pdf.stroke_rectangle [0, 566], 63, 44

    # rectangle
	pdf.stroke_rectangle [443, 471], 24, 18

    # rectangle
    
	pdf.stroke_rectangle [179, 471], 59, 18

    # rectangle
	pdf.stroke_rectangle [227, 464], 9, 9

    # rectangle
	pdf.stroke_rectangle [378, 653], 186, 18

    # rectangle
	pdf.stroke_rectangle [189, 653], 189, 18

    # rectangle
	pdf.stroke_rectangle [342, 713], 222, 18

    # rectangle
	pdf.stroke_rectangle [342, 737], 222, 24

    # rectangle
	pdf.stroke_rectangle [278, 737], 64, 66

    # rectangle
	pdf.stroke_rectangle [326, 708], 9, 10

    # rectangle
	pdf.stroke_rectangle [0, 471], 179, 18

    # rectangle
	pdf.stroke_rectangle [0, 515], 134, 18

    # rectangle
	pdf.stroke_rectangle [0, 497], 91, 18

    # rectangle
	pdf.stroke_rectangle [0, 627], 373, 20

    # rectangle
	pdf.stroke_rectangle [238, 471], 75, 18

    # rectangle
	pdf.stroke_rectangle [133, 515], 115, 18

    # rectangle
	pdf.stroke_rectangle [247, 515], 115, 18

    # rectangle
	pdf.stroke_rectangle [361, 515], 97, 18

    # rectangle
	pdf.stroke_rectangle [457, 515], 107, 18

    # rectangle
	pdf.stroke_rectangle [0, 608], 305, 18

    # rectangle
	pdf.stroke_rectangle [485, 627], 79, 20

    # rectangle
	pdf.stroke_rectangle [372, 627], 113, 20

    # rectangle
	pdf.stroke_rectangle [304, 608], 125, 18

    # rectangle
	pdf.stroke_rectangle [428, 608], 57, 18

    # rectangle
	pdf.stroke_rectangle [227, 591], 111, 18

    # rectangle
	pdf.stroke_rectangle [337, 591], 32, 18

    # rectangle
	pdf.stroke_rectangle [485, 608], 79, 18

    # rectangle
	pdf.stroke_rectangle [485, 591], 79, 18

    # rectangle
	pdf.stroke_rectangle [368, 591], 117, 18

    # rectangle
	pdf.stroke_rectangle [0, 591], 228, 18

    # rectangle
	pdf.stroke_rectangle [269, 497], 92, 18

    # rectangle
	pdf.stroke_rectangle [90, 497], 90, 18

    # rectangle
	pdf.stroke_rectangle [179, 497], 90, 18

    # rectangle
	pdf.stroke_rectangle [457, 497], 107, 18

    # rectangle
	pdf.stroke_rectangle [312, 471], 131, 18

    # rectangle
	pdf.stroke_rectangle [259, 453], 185, 18

    # rectangle
	pdf.stroke_rectangle [467, 471], 97, 18

    # rectangle
	pdf.stroke_rectangle [0, 453], 260, 18

    # rectangle
	pdf.stroke_rectangle [0, 435], 67, 18

    # rectangle
	pdf.stroke_rectangle [67, 435], 117, 18

    # rectangle
	pdf.stroke_rectangle [184, 435], 107, 18

    # rectangle
	pdf.stroke_rectangle [291, 435], 109, 18

    # rectangle
	pdf.stroke_rectangle [443, 453], 24, 18

    # rectangle
	pdf.stroke_rectangle [467, 453], 97, 18

    # rectangle
	pdf.stroke_rectangle [400, 435], 81, 18

    # rectangle
	pdf.stroke_rectangle [481, 435], 83, 18

    # rectangle
	pdf.stroke_rectangle [0, 671], 342, 18

    # rectangle
	pdf.stroke_rectangle [0, 653], 189, 18

    # rectangle
	pdf.stroke_rectangle [0, 789], 457, 20

    # rectangle
	pdf.stroke_rectangle [0, 769], 74, 17

    # rectangle
	pdf.stroke_rectangle [74, 769], 383, 17

    # rectangle
	pdf.stroke_rectangle [189, 566], 63, 44

    # rectangle
	pdf.stroke_rectangle [252, 566], 63, 44

    # rectangle
	pdf.stroke_rectangle [315, 566], 63, 44

    # rectangle
	pdf.stroke_rectangle [378, 566], 63, 44

    # rectangle
	pdf.stroke_rectangle [441, 566], 63, 44

    # rectangle
	pdf.stroke_rectangle [504, 566], 60, 44

    # rectangle
	pdf.stroke_rectangle [0, 407], 564, 213

    # rectangle
	pdf.stroke_rectangle [0, 157], 341, 173

    # rectangle
	pdf.stroke_rectangle [341, 157], 223, 173

    # rectangle
	pdf.stroke_rectangle [0, 186], 112, 20

    # rectangle
	pdf.stroke_rectangle [111, 186], 145, 20

    # rectangle
	pdf.stroke_rectangle [255, 186], 145, 20

    # rectangle
	pdf.stroke_rectangle [399, 186], 165, 20

    # staticText
    pdf.draw_text "PROTOCOLO DE AUTORIZAÇÃO DE USO", :size => 5, :at => [346, 666], :width => 142, :height => 7

    # textField xml['infProt/nProt'] + ' ' + xml['infProt/dhRecbto']
    pdf.draw_text xml['infProt/nProt'] + ' ' + xml['infProt/dhRecbto'], :size => 6, :at => [347, 657], :width => 215, :height => 9

    # staticText
    pdf.draw_text "Consulta de autenticidade no portal nacional da NF-e www.nfe.fazenda.gov.br/portal ou no site da Sefaz Autorizadora", :size => 6, :at => [344, 678], :width => 218, :height => 17

    # staticText
    pdf.draw_text "N°.", :size => 7, :at => [460, 768], :width => 9, :height => 9

    # staticText
    pdf.draw_text "DESTINATÁRIO / REMETENTE", :size => 5, :at => [0, 631], :width => 109, :height => 8

    # staticText
    pdf.draw_text "CNPJ/CPF", :size => 5, :at => [375, 622], :width => 46, :height => 7

    # staticText
    pdf.draw_text "DATA DA EMISSÃO", :size => 5, :at => [488, 622], :width => 49, :height => 7

    # staticText
    pdf.draw_text "NOME/RAZÃO SOCIAL", :size => 5, :at => [3, 622], :width => 107, :height => 7

    # staticText
    pdf.draw_text "ENDEREÇO", :size => 5, :at => [3, 603], :width => 107, :height => 7

    # staticText
    pdf.draw_text "BAIRRO / DISTRITO", :size => 5, :at => [307, 603], :width => 69, :height => 7

    # staticText
    pdf.draw_text "CEP", :size => 5, :at => [429, 603], :width => 30, :height => 7

    # staticText
    pdf.draw_text "FONE/FAX", :size => 5, :at => [231, 586], :width => 49, :height => 7

    # staticText
    pdf.draw_text "UF", :size => 5, :at => [340, 586], :width => 17, :height => 7

    # staticText
    pdf.draw_text "FATURA / DUPLICATAS", :size => 5, :at => [0, 570], :width => 109, :height => 7

    # staticText
    pdf.draw_text "CÁLCULO DO IMPOSTO", :size => 5, :at => [0, 519], :width => 109, :height => 7

    # staticText
    pdf.draw_text "BASE DE CÁLCULO DO ICMS", :size => 5, :at => [3, 510], :width => 73, :height => 7

    # staticText
    pdf.draw_text "VALOR DO ICMS", :size => 5, :at => [136, 510], :width => 78, :height => 7

    # staticText
    pdf.draw_text "BASE DE CÁLCULO DO ICMS ST", :size => 5, :at => [250, 510], :width => 80, :height => 7

    # staticText
    pdf.draw_text "VALOR DO ICMS ST", :size => 5, :at => [364, 510], :width => 59, :height => 7

    # staticText
    pdf.draw_text "VALOR TOTAL DOS PRODUTOS", :size => 5, :at => [460, 510], :width => 79, :height => 7

    # staticText
    pdf.draw_text "TRANSPORTADOR / VOLUMES TRANSPORTADOS DADOS DO PRODUTO / SERVIÇODADOS DO PRODUTO / SERVIÇODADOS DO PRODUTO / SERVIÇO", :size => 5, :at => [0, 475], :width => 134, :height => 8

    # staticText
    pdf.draw_text "RAZÃO SOCIAL", :size => 5, :at => [3, 466], :width => 64, :height => 7

    # staticText
    pdf.draw_text "FRETE POR CONTA", :size => 5, :at => [181, 466], :width => 49, :height => 7

    # staticText
    pdf.draw_text "CÓDIGO ANTT", :size => 5, :at => [241, 466], :width => 49, :height => 7

    # staticText
    pdf.draw_text "0-EMITENTE 1-DESTINATÁRIO", :size => 4, :at => [181, 456], :width => 44, :height => 12

    # textField dest/xNome
    pdf.draw_text xml['dest/xNome'], :size => 7, :at => [3, 612], :width => 366, :height => 9

    # textField enderDest/xLgr enderDest/nro
    pdf.draw_text xml['enderDest/xLgr'] + " " + xml['enderDest/nro'], :size => 7, :at => [3, 595], :width => 298, :height => 9

    # textField dest/CNPJ
    pdf.draw_text xml['dest/CNPJ'], :size => 7, :at => [375, 612], :width => 107, :height => 9

    # textField ide/dEmi
    pdf.draw_text xml['ide/dEmi'], :size => 7, :at => [488, 612], :width => 74, :height => 9

    # textField enderDest/xBairro
    pdf.draw_text xml['enderDest/xBairro'], :size => 7, :at => [307, 595], :width => 119, :height => 9

    # textField enderDest/CEP
    pdf.draw_text xml['enderDest/CEP'], :size => 7, :at => [429, 595], :width => 55, :height => 9

    # textField enderDest/UF
    pdf.draw_text xml['enderDest/UF'], :size => 7, :at => [340, 577], :width => 26, :height => 9

    # textField enderDest/fone
    pdf.draw_text xml['enderDest/fone'], :size => 7, :at => [231, 577], :width => 104, :height => 9

    # textField total/vBC
    pdf.draw_text xml['total/vBC'], :size => 7, :at => [3, 501], :width => 127, :height => 9

    # textField total/vICMS
    pdf.draw_text xml['total/vICMS'], :size => 7, :at => [136, 501], :width => 108, :height => 9

    # textField total/vBCST
    pdf.draw_text xml['total/vBCST'], :size => 7, :at => [250, 501], :width => 108, :height => 9

    # textField total/vST
    pdf.draw_text xml['total/vST'], :size => 7, :at => [364, 501], :width => 90, :height => 9

    # textField total/vProd
    pdf.draw_text xml['total/vProd'], :size => 7, :at => [460, 501], :width => 101, :height => 9

    # textField transporta/xNome
    pdf.draw_text xml['transporta/xNome'], :size => 7, :at => [3, 457], :width => 174, :height => 9

    # textField transp/modFrete
    pdf.draw_text xml['transp/modFrete'], :size => 5, :at => [228, 460], :width => 7, :height => 7

    # textField veicTransp/RNTC
    pdf.draw_text xml['veicTransp/RNTC'], :size => 5, :at => [241, 457], :width => 69, :height => 9

    # staticText DATA DA SAÍDA/ENTRADA
    pdf.draw_text "DATA DA SAÍDA/ENTRADA", :size => 5, :at => [488, 603], :width => 69, :height => 7

    # staticText HORA DE SAÍDA
    pdf.draw_text "HORA DE SAÍDA", :size => 5, :at => [488, 586], :width => 53, :height => 7

    # staticText INSCRIÇÃO ESTADUAL
    pdf.draw_text "INSCRIÇÃO ESTADUAL", :size => 5, :at => [371, 586], :width => 79, :height => 7

    # textField $F{NR_IE_DESTINO}
    pdf.draw_text xml['dest/IE'], :size => 7, :at => [371, 577], :width => 111, :height => 9

    # textField $F{DS_MUNICIPIO_DESTINO}
    pdf.draw_text xml['enderDest/xMun'], :size => 7, :at => [3, 577], :width => 222, :height => 9

    # staticText MUNICÍPIO
    pdf.draw_text "MUNICÍPIO", :size => 5, :at => [3, 586], :width => 107, :height => 7

    # staticText Número
    pdf.draw_text "Número", :size => 5, :at => [3, 562], :width => 57, :height => 7

    # staticText Vencimento
    pdf.draw_text "Vencimento", :size => 5, :at => [67, 562], :width => 56, :height => 7

    # staticText Valor
    pdf.draw_text "Valor", :size => 5, :at => [130, 562], :width => 55, :height => 7

    # textField $F{VL_OUTROS}
    pdf.draw_text xml['total/vOutros'], :size => 7, :at => [272, 483], :width => 86, :height => 9

    # staticText OUTRAS DESPESAS ACESSÓRIAS
    pdf.draw_text "OUTRAS DESPESAS ACESSÓRIAS", :size => 5, :at => [272, 492], :width => 84, :height => 7

    # textField $F{VL_SEGURO}
    pdf.draw_text xml['total/vSeg'], :size => 7, :at => [93, 483], :width => 83, :height => 9

    # staticText VALOR DO SEGURO
    pdf.draw_text "VALOR DO SEGURO", :size => 5, :at => [93, 492], :width => 59, :height => 7

    # staticText DESCONTO
    pdf.draw_text "DESCONTO", :size => 5, :at => [182, 492], :width => 35, :height => 7

    # textField $F{VL_DESCONTO}
    pdf.draw_text xml['total/vDesc'], :size => 7, :at => [182, 483], :width => 85, :height => 9

    # staticText VALOR DO FRETE
    pdf.draw_text "VALOR DO FRETE", :size => 5, :at => [3, 492], :width => 50, :height => 7

    # textField $F{VL_FRETE}
    pdf.draw_text xml['total/vlFrete'], :size => 7, :at => [3, 483], :width => 84, :height => 9

    # textField $F{VL_NF}
    pdf.draw_text xml['total/vNF'], :size => 7, :at => [461, 483], :width => 99, :height => 9

    # staticText VALOR TOTAL DA NOTA
    pdf.draw_text "VALOR TOTAL DA NOTA", :size => 5, :at => [461, 492], :width => 61, :height => 7

    # staticText PLACA DO VEÍCULO
    pdf.draw_text "PLACA DO VEÍCULO", :size => 5, :at => [315, 466], :width => 69, :height => 7

    # staticText CNPJ / CPF
    pdf.draw_text "CNPJ / CPF", :size => 5, :at => [469, 466], :width => 69, :height => 7

    # textField transporta/CNPJ
    pdf.draw_text xml['transporta/CNPJ'], :size => 7, :at => [469, 457], :width => 92, :height => 9

    # textField transporta/xMun
    pdf.draw_text xml['transporta/xMun'], :size => 7, :at => [263, 439], :width => 177, :height => 10

    # staticText
    pdf.draw_text "MUNICÍPIO", :size => 5, :at => [263, 448], :width => 64, :height => 7

    # textField transporta/xEnder
    pdf.draw_text xml['transporta/xEnder'], :size => 7, :at => [3, 439], :width => 255, :height => 9

    # staticText
    pdf.draw_text "ENDEREÇO", :size => 5, :at => [3, 448], :width => 64, :height => 7

    # staticText
    pdf.draw_text "QUANTIDADE", :size => 5, :at => [3, 430], :width => 39, :height => 7

    # textField vol/qVol
    pdf.draw_text xml['vol/qVol'], :size => 7, :at => [3, 421], :width => 60, :height => 9

    # textField vol/esp
    pdf.draw_text xml['vol/esp'], :size => 7, :at => [70, 421], :width => 111, :height => 9

    # staticText
    pdf.draw_text "ESPÉCIE", :size => 5, :at => [70, 430], :width => 29, :height => 7

    # staticText
    pdf.draw_text "MARCA", :size => 5, :at => [187, 430], :width => 62, :height => 7

    # textField vol/marca
    pdf.draw_text xml['vol/marca'], :size => 7, :at => [187, 421], :width => 97, :height => 9

    # staticText
    pdf.draw_text "NUMERAÇÃO", :size => 5, :at => [294, 430], :width => 62, :height => 7

    # textField
    pdf.draw_text "", :size => 7, :at => [294, 421], :width => 103, :height => 9

    # staticText UF
    pdf.draw_text "UF", :size => 5, :at => [446, 448], :width => 14, :height => 7

    # textField tranporta/UF
    pdf.draw_text xml['tranporta/UF'], :size => 7, :at => [446, 439], :width => 19, :height => 9

    # textField transporta/IE
    pdf.draw_text xml['transporta/IE'], :size => 7, :at => [470, 439], :width => 91, :height => 9

    # staticText
    pdf.draw_text "INSCRIÇÃO ESTADUAL", :size => 5, :at => [470, 448], :width => 69, :height => 7

    # staticText
    pdf.draw_text "PESO BRUTO", :size => 5, :at => [403, 430], :width => 76, :height => 7

    # textField vol/pesoB
    pdf.draw_text xml['vol/pesoB'], :size => 7, :at => [403, 421], :width => 76, :height => 9

    # textField 'vol/pesoL'
    pdf.draw_text xml['vol/pesoL'], :size => 7, :at => [484, 421], :width => 77, :height => 9

    # staticText
    pdf.draw_text "PESO LÍQUIDO", :size => 5, :at => [484, 430], :width => 76, :height => 7

    # textField transp/pĺaca
    pdf.draw_text xml['transp/pĺaca'], :size => 7, :at => [315, 457], :width => 125, :height => 9

    # staticText UF
    pdf.draw_text "UF", :size => 5, :at => [446, 466], :width => 8, :height => 7

    # textField transp/UF
    pdf.draw_text xml['transp/UF'], :size => 7, :at => [446, 457], :width => 18, :height => 9

    # staticText
    pdf.draw_text "VALOR DO IPI", :size => 5, :at => [364, 492], :width => 43, :height => 7

    # textField total/vIPI
    pdf.draw_text xml['total/vIPI'], :size => 7, :at => [364, 483], :width => 90, :height => 9

    # staticText
    pdf.draw_text "DANFE", :size => 10, :at => [281, 729], :width => 58, :height => 12

    # staticText
    pdf.draw_text "DOCUMENTO AUXILIAR DA NOTA FISCAL ELETRÔNICA", :size => 5, :at => [280, 715], :width => 60, :height => 17

    # staticText
    pdf.draw_text "0 - ENTRADA 1 - SAÍDA", :size => 5, :at => [286, 699], :width => 34, :height => 14

    # staticText
    pdf.draw_text "NATUREZA DA OPERAÇÃO", :size => 5, :at => [3, 666], :width => 107, :height => 7

    # staticText
    pdf.draw_text "INSCRIÇÃO ESTADUAL", :size => 5, :at => [3, 648], :width => 69, :height => 7

    # staticText
    pdf.draw_text "INSC.ESTADUAL DO SUBST. TRIBUTÁRIO", :size => 5, :at => [192, 648], :width => 107, :height => 7

    # staticText
    pdf.draw_text "CNPJ", :size => 5, :at => [381, 648], :width => 16, :height => 7

    # textField ide/natOp
    pdf.draw_text xml['ide/natOp'], :size => 7, :at => [3, 657], :width => 336, :height => 9

    # textField emit/IE
    pdf.draw_text xml['emit/IE'], :size => 7, :at => [3, 639], :width => 183, :height => 9

    # textField emit/IE_ST
    pdf.draw_text xml['emit/IE_ST'], :size => 7, :at => [192, 639], :width => 183, :height => 9

    # textField emit/CNPJ
    pdf.draw_text xml['emit/CNPJ'], :size => 7, :at => [381, 639], :width => 181, :height => 9

    # textField ide/dSaiEnt
    pdf.draw_text xml['ide/dSaiEnt'], :size => 5, :at => [328, 704], :width => 5, :height => 6

    # textField ide/serie
    pdf.draw_text xml['ide/serie'], :size => 6, :at => [301, 683], :width => 38, :height => 7

    # staticText 
    pdf.draw_text "SÉRIE", :size => 6, :at => [282, 683], :width => 19, :height => 7

    # textField ide/nNF
    pdf.draw_text xml['ide/nNF'], :size => 7, :at => [291, 690], :width => 48, :height => 9

    # staticText
    pdf.draw_text "DATA DE RECEBIMENTO", :size => 5, :at => [3, 764], :width => 65, :height => 7

    # staticText
    pdf.draw_text "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", :size => 5, :at => [77, 764], :width => 259, :height => 7

    # staticText
    pdf.draw_text "NF-e", :size => 9, :at => [460, 778], :width => 102, :height => 12

    # textField ide/serie
    pdf.draw_text xml['ide/serie'], :size => 7, :at => [486, 759], :width => 76, :height => 9

    # textField ide/nNF
    pdf.draw_text xml['ide/nNF'], :size => 7, :at => [469, 768], :width => 93, :height => 9

    # textField
    pdf.draw_text "RECEBEMOS DE " + xml['emit/xNome'] + " OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA A BAIXO", :size => 5, :at => [3, 784], :width => 450, :height => 8

    # staticText
    pdf.draw_text "SÉRIE", :size => 7, :at => [460, 759], :width => 26, :height => 9

    # staticText
    pdf.draw_text "CHAVE DE ACESSO", :size => 5, :at => [345, 708], :width => 67, :height => 7

    # staticText
    pdf.draw_text "FOLHA", :size => 6, :at => [282, 676], :width => 19, :height => 7

    # textField
    pdf.draw_text " 1 / 1", :size => 6, :at => [301, 676], :width => 9, :height => 7

    # textField chNFe
    pdf.draw_text xml['chNFe'], :size => 6, :at => [345, 699], :width => 217, :height => 9

    # staticText
    pdf.draw_text "DADOS DO PRODUTO / SERVIÇO", :size => 5, :at => [0, 412], :width => 134, :height => 8

    # staticText
    pdf.draw_text "N°", :size => 7, :at => [282, 690], :width => 10, :height => 9

    # textField emit/xNome
    pdf.draw_text xml['emit/xNome'], :size => 7, :at => [76, 720], :width => 198, :height => 21

    # textField enderEmit/xLgr enderEmit/nro
    pdf.draw_text xml['enderEmit/xLgr'] + ", " + xml['enderEmit/nro'], :size => 7, :at => [76, 709], :width => 198, :height => 10

    # textField enderEmit/xBairro
    pdf.draw_text xml['enderEmit/xBairro'] + " - " + xml['enderEmit/CEP'], :size => 7, :at => [76, 699], :width => 198, :height => 10

    # textField enderEmit/xMun enderEmit/UF
    pdf.draw_text xml['enderEmit/xMun'] + "/" + xml['enderEmit/UF'], :size => 6, :at => [76, 689], :width => 198, :height => 10

    # textField enderEmit/fone enderEmit/email
    pdf.draw_text xml['enderEmit/fone'] + " " + xml['enderEmit/email'], :size => 6, :at => [76, 679], :width => 198, :height => 10

    # textField ide/dSaiEnt
    pdf.draw_text xml['ide/dSaiEnt'], :size => 7, :at => [488, 595], :width => 74, :height => 9

    # textField ide/dSaiEnt
    pdf.draw_text xml['ide/dSaiEnt'], :size => 7, :at => [488, 577], :width => 74, :height => 9

    # staticText
    pdf.draw_text "Número", :size => 5, :at => [192, 562], :width => 57, :height => 7

    # staticText
    pdf.draw_text "Vencimento", :size => 5, :at => [256, 562], :width => 56, :height => 7

    # staticText
    pdf.draw_text "Valor", :size => 5, :at => [319, 562], :width => 55, :height => 7

    # staticText
    pdf.draw_text "Número", :size => 5, :at => [381, 562], :width => 57, :height => 7

    # staticText
    pdf.draw_text "Vencimento", :size => 5, :at => [445, 562], :width => 56, :height => 7

    # staticText
    pdf.draw_text "Valor", :size => 5, :at => [508, 562], :width => 50, :height => 7

    # textField infAdic/infCpl
    pdf.draw_text xml['infAdic/infCpl'], :size => 6, :at => [-10, -50], :width => 334, :height => 161

    # staticText
    pdf.draw_text "DADOS ADICIONAIS", :size => 5, :at => [0, 161], :width => 134, :height => 7

    # staticText
    pdf.draw_text "CÁLCULO DO ISSQN", :size => 5, :at => [0, 190], :width => 134, :height => 8

    # staticText
    pdf.draw_text "INSCRIÇÃO MUNICIPAL", :size => 5, :at => [3, 181], :width => 83, :height => 8

    # staticText
    pdf.draw_text "VALOR TOTAL DOS SERVIÇOS", :size => 5, :at => [114, 181], :width => 103, :height => 8

    # textField total/vServ
    pdf.draw_text xml['total/vServ'], :size => 7, :at => [114, 170], :width => 138, :height => 10

    # textField emit/IM
    pdf.draw_text xml['emit/IM'], :size => 7, :at => [3, 170], :width => 105, :height => 10

    # staticText 
    pdf.draw_text "BASE DE CÁLCULO DO ISSQN", :size => 5, :at => [258, 181], :width => 103, :height => 8

    # textField total/vBCISS
    pdf.draw_text xml['total/vBCISS'], :size => 7, :at => [258, 170], :width => 138, :height => 10

    # staticText 
    pdf.draw_text "VALOR DO ISSQN", :size => 5, :at => [402, 181], :width => 103, :height => 8

    # textField total/ISSTot
    pdf.draw_text xml['total/ISSTot'], :size => 7, :at => [402, 170], :width => 159, :height => 10

    # textField 
    pdf.draw_text "", :size => 6, :at => [331, -50], :width => 216, :height => 163

    # staticText
    pdf.draw_text "RESERVADO AO FISCO", :size => 5, :at => [345, 153], :width => 96, :height => 7

    # staticText
    pdf.draw_text "INFORMAÇÕES COMPLEMENTARES", :size => 5, :at => [3, 152], :width => 93, :height => 7

    return pdf
      
  end
  
  def self.render(xml_string)  
    xml = XML.new(xml_string)
    pdf = generatePDFFromXML(xml)
    return pdf.render
  end
  
  def self.generate(pdf_filename, xml_filename)
    xml = XML.new(File.new(xml_filename))
    pdf = generatePDFFromXML(xml)
    pdf.render_file pdf_filename
  end
  
end
