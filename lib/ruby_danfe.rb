# -*- encoding : utf-8 -*-
require 'rubygems'
require 'prawn'
require 'prawn/measurement_extensions'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
require 'nokogiri'

def numerify(number, decimals = 2)
  return '' if !number || number == ''
  int, frac = ("%.#{decimals}f" % number).split('.')
  int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1\.")  
  int + "," + frac
end

def invert(y)
  28.7.cm - y
end

module RubyDanfe

  version = "0.9.0"

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
    def collect(xpath, &block)
      result = []
      @xml.xpath(xpath).each do |det|
        result << yield(det)
      end
      result
    end
  end
  
  class Document < Prawn::Document
  
       
    def ititle(h, w, x, y, title)
      self.text_box title, :size => 10, :at => [x.cm, invert(y.cm) - 2], :width => w.cm, :height => h.cm, :style => :bold
    end
   
    def ibarcode(h, w, x, y, info)
      Barby::Code128C.new(info).annotate_pdf(self, :x => x.cm, :y => invert(y.cm), :width => w.cm, :height => h.cm) if info != ''
    end
     
    def irectangle(h, w, x, y)
      self.stroke_rectangle [x.cm, invert(y.cm)], w.cm, h.cm
    end
    
    def ibox(h, w, x, y, title = '', info = '', options = {})
      box [x.cm, invert(y.cm)], w.cm, h.cm, title, info, options
    end
    
    def idate(h, w, x, y, title = '', info = '', options = {})
      tt = info.split('-')
      ibox h, w, x, y, title, "#{tt[2]}/#{tt[1]}/#{tt[0]}", options
    end
    
    def box(at, w, h, title = '', info = '', options = {})
      options = {
        :align => :left,
        :size => 10,
        :style => nil,
        :valign => :top,
        :border => 1
      }.merge(options)
      self.stroke_rectangle at, w, h if options[:border] == 1
      self.text_box title, :size => 6, :at => [at[0] + 2, at[1] - 2], :width => w - 4, :height => 8 if title != ''
      self.text_box info, :size => options[:size], :at => [at[0] + 2, at[1] - (title != '' ? 14 : 4) ], :width => w - 4, :height => h - (title != '' ? 14 : 4), :align => options[:align], :style => options[:style], :valign => options[:valign]
    end
    
    def inumeric(h, w, x, y, title = '', info = '', options = {})
      numeric [x.cm, invert(y.cm)], w.cm, h.cm, title, info, options
    end

    def numeric(at, w, h, title = '', info = '', options = {})
      options = {:decimals => 2}.merge(options)
      info = numerify(info, options[:decimals]) if info != ''
      box at, w, h, title, info, options.merge({:align => :right})
    end
       
    def itable(h, w, x, y, data, options = {}, &block)
      self.bounding_box [x.cm, invert(y.cm)], :width => w.cm, :height => h.cm do
        self.table data, options do |table|
          yield(table)
        end
      end
    end
  end
  
  def self.generatePDF(xml)
  
    pdf = Document.new(
      :page_size => 'A4',
      :page_layout => :portrait,
      :left_margin => 0,
      :right_margin => 0,
      :top_margin => 0,
      :botton_margin => 0
    )
 
    pdf.font "Times-Roman" # Official font   
    
    pdf.repeat :all do
    
    # CANHOTO
        
    pdf.ibox 0.85, 16.10, 0.25, 0.42, "RECEBEMOS DE " + xml['emit/xNome'] + " OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA ABAIXO"
    pdf.ibox 0.85, 4.10, 0.25, 1.27, "DATA DE RECEBIMENTO"
  	pdf.ibox 0.85, 12.00, 4.35, 1.27, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR"

  	pdf.ibox 1.70, 4.50, 16.35, 0.42, '', 
  	  "NF-e\n" +
  	  "N°. " + xml['ide/nNF'] + "\n" +
  	  "SÉRIE " + xml['ide/serie'], {:align => :center, :valign => :center}

    # EMITENTE
    
    pdf.ibox 3.92, 7.46, 0.25, 2.54, '', 
      xml['emit/xNome'] + "\n" +
      xml['enderEmit/xLgr'] + ", " + xml['enderEmit/nro'] + "\n" + 
      xml['enderEmit/xBairro'] + " - " + xml['enderEmit/CEP'] + "\n" +
      xml['enderEmit/xMun'] + "/" + xml['enderEmit/UF'] + "\n" +
      xml['enderEmit/fone'] + " " + xml['enderEmit/email'], {:align => :center, :valign => :center}
      
    pdf.ibox 3.92, 3.08, 7.71, 2.54
    
    pdf.ibox 0.60, 3.08, 7.71, 2.54, '', "DANFE", {:size => 12, :align => :center, :border => 0, :style => :bold}
    pdf.ibox 1.20, 3.08, 7.71, 3.14, '', "DOCUMENTO AUXILIAR DA NOTA FISCAL ELETRÔNICA", {:size => 8, :align => :center, :border => 0}
    pdf.ibox 0.60, 3.08, 7.71, 4.34, '', "#{xml['ide/tpNF']} - " + (xml['ide/tpNF'] == '0' ? 'ENTRADA' : 'SAÍDA'), {:size => 8, :align => :center, :border => 0}

    pdf.ibox 1.00, 3.08, 7.71, 4.94, '', 
  	  "N°. " + xml['ide/nNF'] + "\n" +
  	  "SÉRIE " + xml['ide/serie'], {:size => 8, :align => :center, :valign => :center, :border => 0, :style => :bold}
        
    pdf.ibox 2.20, 10.02, 10.79, 2.54
    pdf.ibarcode 1.50, 8.00, 10.9010, 4.44, xml['chNFe']
    pdf.ibox 0.85, 10.02, 10.79, 4.74, "CHAVE DE ACESSO", xml['chNFe'].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "), {:style => :bold, :align => :center}
    pdf.ibox 0.85, 10.02, 10.79, 5.60 , '', "Consulta de autenticidade no portal nacional da NF-e www.nfe.fazenda.gov.br/portal ou no site da Sefaz Autorizadora", {:align => :center, :size => 8}
	  pdf.ibox 0.85, 10.54, 0.25, 6.46, "NATUREZA DA OPERAÇÃO", xml['ide/natOp']
	  pdf.ibox 0.85, 10.02, 10.79, 6.46, "PROTOCOLO DE AUTORIZAÇÃO DE USO", xml['infProt/nProt'] + ' ' + xml['infProt/dhRecbto'], {:align => :center}

	  pdf.ibox 0.85, 6.86, 0.25, 7.31, "INSCRIÇÃO ESTADUAL", xml['emit/IE']
	  pdf.ibox 0.85, 6.86, 7.11, 7.31, "INSC.ESTADUAL DO SUBST. TRIBUTÁRIO", xml['emit/IE_ST']
	  pdf.ibox 0.85, 6.84, 13.97, 7.31, "CNPJ", xml['emit/CNPJ']
            
    # TITULO
    
    pdf.ititle 0.42, 10.00, 0.25, 8.16, "DESTINATÁRIO / REMETENTE"

	  pdf.ibox 0.85, 12.32, 0.25, 8.58, "NOME/RAZÃO SOCIAL", xml['dest/xNome']
	  pdf.ibox 0.85, 5.33, 12.57, 8.58, "CNPJ/CPF", xml['dest/CNPJ'] if xml['dest/CNPJ'] != ''
	  pdf.ibox 0.85, 5.33, 12.57, 8.58, "CNPJ/CPF", xml['dest/CPF'] if xml['dest/CPF'] != ''
	  pdf.idate 0.85, 2.92, 17.90, 8.58, "DATA DA EMISSÃO", xml['ide/dEmi'], {:align => :right}
	  pdf.ibox 0.85, 10.16, 0.25, 9.43, "ENDEREÇO", xml['enderDest/xLgr'] + " " + xml['enderDest/nro']
	  pdf.ibox 0.85, 4.83, 10.41, 9.43, "BAIRRO", xml['enderDest/xBairro']
	  pdf.ibox 0.85, 2.67, 15.24, 9.43, "CEP", xml['enderDest/CEP']
	  pdf.idate 0.85, 2.92, 17.90, 9.43, "DATA DA SAÍDA/ENTRADA", xml['ide/dSaiEnt'], {:align => :right}
	  pdf.ibox 0.85, 7.11, 0.25, 10.28, "MUNICÍPIO", xml['enderDest/xMun']
	  pdf.ibox 0.85, 4.06, 7.36, 10.28, "FONE/FAX", xml['enderDest/fone']
	  pdf.ibox 0.85, 1.14, 11.42, 10.28, "UF", xml['enderDest/UF']
	  pdf.ibox 0.85, 5.33, 12.56, 10.28, "INSCRIÇÃO ESTADUAL", xml['dest/IE']
	  pdf.idate 0.85, 2.92, 17.90, 10.28, "HORA DE SAÍDA", xml['ide/dSaiEnt'], {:align => :right}

    # FATURAS
    
    pdf.ititle 0.42, 10.00, 0.25, 11.12, "FATURA / DUPLICATAS"
    pdf.ibox 0.85, 20.57, 0.25, 11.51

    if false
	  pdf.box [0, 563], 63, 44, "Número"
	  pdf.box [63, 563], 63, 44, "Vencimento"	
	  pdf.box [126, 563], 63, 44, "Valor"
	  pdf.box [189, 563], 63, 44, "Número"
	  pdf.box [252, 563], 63, 44, "Vencimento"	
	  pdf.box [315, 563], 63, 44, "Valor"
	  pdf.box [378, 563], 63, 44, "Número"
	  pdf.box [441, 563], 63, 44, "Vencimento"
	  pdf.box [504, 563], 60, 44, "Valor"
    end
    
    pdf.ititle 0.42, 5.60, 0.25, 12.36, "CÁLCULO DO IMPOSTO"

  	pdf.inumeric 0.85, 4.06, 0.25, 12.78, "BASE DE CÁLCULO DO ICMS", xml['ICMSTot/vBC']
  	pdf.inumeric 0.85, 4.06, 4.31, 12.78, "VALOR DO ICMS", xml['ICMSTot/vICMS']
  	pdf.inumeric 0.85, 4.06, 8.37, 12.78, "BASE DE CÁLCULO DO ICMS ST", xml['ICMSTot/vBCST']
  	pdf.inumeric 0.85, 4.06, 12.43, 12.78, "VALOR DO ICMS ST", xml['ICMSTot/vST']
  	pdf.inumeric 0.85, 4.32, 16.49, 12.78, "VALOR TOTAL DOS PRODUTOS", xml['ICMSTot/vProd']
	  pdf.inumeric 0.85, 3.46, 0.25, 13.63, "VALOR DO FRETE", xml['ICMSTot/vFrete']
	  pdf.inumeric 0.85, 3.46, 3.71, 13.63, "VALOR DO SEGURO", xml['ICMSTot/vSeg']
	  pdf.inumeric 0.85, 3.46, 7.17, 13.63, "DESCONTO", xml['ICMSTot/vDesc']
	  pdf.inumeric 0.85, 3.46, 10.63, 13.63, "OUTRAS DESPESAS ACESSORIAS", xml['ICMSTot/vOutro']
	  pdf.inumeric 0.85, 3.46, 14.09, 13.63, "VALOR DO IPI", xml['ICMSTot/vIPI']
	  pdf.inumeric 0.85, 3.27, 17.55, 13.63, "VALOR TOTAL DA NOTA", xml['ICMSTot/vNF'], :style => :bold
	
    pdf.ititle 0.42, 10.00, 0.25, 14.48, "TRANSPORTADOR / VOLUMES TRANSPORTADOS"

  	pdf.ibox 0.85, 9.02, 0.25, 14.90, "RAZÃO SOCIAL", xml['transporta/xNome']
	  pdf.ibox 0.85, 2.79, 9.27, 14.90, "FRETE POR CONTA", xml['transp/modFrete'] == '0' ? ' 0 - EMITENTE' : '1 - DEST.'
	  pdf.ibox 0.85, 1.78, 12.06, 14.90, "CODIGO ANTT", xml['veicTransp/RNTC']
	  pdf.ibox 0.85, 2.29, 13.84, 14.90, "PLACA DO VEÍCULO", xml['veicTransp/placa']
	  pdf.ibox 0.85, 0.76, 16.13, 14.90, "UF", xml['veicTransp/UF']
	  pdf.ibox 0.85, 3.94, 16.89, 14.90, "CNPJ/CPF", xml['transporta/CNPJ'] 
  	pdf.ibox 0.85, 9.02, 0.25, 15.75, "ENDEREÇO", xml['transporta/xEnder']
  	pdf.ibox 0.85, 6.86, 9.27, 15.75, "MUNICÍPIO", xml['transporta/xMun']
    pdf.ibox 0.85, 0.76, 16.13, 15.75, "UF", xml['transporta/UF']
  	pdf.ibox 0.85, 3.94, 16.89, 15.75, "INSCRIÇÂO ESTADUAL", xml['transporta/IE']
	  pdf.ibox 0.85, 2.92, 0.25, 16.60, "QUANTIDADE", xml['vol/qVol']
	  pdf.ibox 0.85, 3.05, 3.17, 16.60, "ESPÉCIE", xml['vol/esp']
	  pdf.ibox 0.85, 3.05, 6.22, 16.60, "MARCA", xml['vol/marca']
	  pdf.ibox 0.85, 4.83, 9.27, 16.60, "NUMERAÇÃO"
	  pdf.inumeric 0.85, 3.43, 14.10, 16.60, "PESO BRUTO", xml['vol/pesoB'], {:decimals => 3}
	  pdf.inumeric 0.85, 3.30, 17.53, 16.60, "PESO LÍQUIDO", xml['vol/pesoL'], {:decimals => 3}

    pdf.ititle 0.42, 10.00, 0.25, 17.45, "DADOS DO PRODUTO / SERVIÇO"

    pdf.ibox 6.77, 2.00, 0.25, 17.87, "CÓDIGO"
    pdf.ibox 6.77, 4.50, 2.25, 17.87, "DESCRIÇÃO"
    pdf.ibox 6.77, 1.50, 6.75, 17.87, "NCM"
    pdf.ibox 6.77, 0.80, 8.25, 17.87, "CST"
    pdf.ibox 6.77, 1.00, 9.05, 17.87, "CFOP"
    pdf.ibox 6.77, 1.00, 10.05, 17.87, "UNID"
    pdf.ibox 6.77, 1.50, 11.05, 17.87, "QUANT"
    pdf.ibox 6.77, 1.50, 12.55, 17.87, "VALOR UNIT"
    pdf.ibox 6.77, 1.50, 14.05, 17.87, "VALOR TOT"
    pdf.ibox 6.77, 1.50, 15.55, 17.87, "BASE CÁLC"
    pdf.ibox 6.77, 1.00, 17.05, 17.87, "VL ICMS"
    pdf.ibox 6.77, 1.00, 18.05, 17.87, "VL IPI"
    pdf.ibox 6.77, 0.90, 19.05, 17.87, "% ICMS"
    pdf.ibox 6.77, 0.86, 19.95, 17.87, "% IPI"

    pdf.horizontal_line 0.25.cm, 21.50.cm, :at => invert(18.17.cm)
	  
    pdf.ititle 0.42, 10.00, 0.25, 24.64, "CÁLCULO DO ISSQN"

	  pdf.ibox 0.85, 5.08, 0.25, 25.06, "INSCRIÇÃO MUNICIPAL", xml['emit/IM']
	  pdf.ibox 0.85, 5.08, 5.33, 25.06, "VALOR TOTAL DOS SERVIÇOS", xml['total/vServ']
	  pdf.ibox 0.85, 5.08, 10.41, 25.06, "BASE DE CÁLCULO DO ISSQN", xml['total/vBCISS']
	  pdf.ibox 0.85, 5.28, 15.49, 25.06, "VALOR DO ISSQN", xml['total/ISSTot']

    pdf.ititle 0.42, 10.00, 0.25, 25.91, "DADOS ADICIONAIS"

	  pdf.ibox 3.07, 12.93, 0.25, 26.33, "INFORMAÇÕES COMPLEMENTARES", xml['infAdic/infCpl'], {:size => 8, :valign => :top}
	  
	  pdf.ibox 3.07, 7.62, 13.17, 26.33, "RESERVADO AO FISCO"

    end

    
    pdf.font_size(6) do
      pdf.itable 6.37, 21.50, 0.25, 18.17, 
        xml.collect('//xmlns:det') { |det|
          [
            det.css('prod/cProd').text, #I02
            det.css('prod/xProd').text, #I04
            det.css('prod/NCM').text, #I05
            det.css('ICMS/*/orig').text, #N11
            det.css('prod/CFOP').text, #I08
            det.css('prod/uCom').text, #I09
            numerify(det.css('prod/qCom').text), #I10 
            numerify(det.css('prod/vUnCom').text), #I10a
            numerify(det.css('prod/vProd').text), #I11
            numerify(det.css('ICMS/*/vBC').text), #N15
            numerify(det.css('ICMS/*/vICMS').text), #N17   
            numerify(det.css('IPI/*/vIPI').text), #O14
            numerify(det.css('ICMS/*/pICMS').text), #N16
            numerify(det.css('IPI/*/pIPI').text) #O13 
          ]
        },
        :column_widths => {
          0 => 2.00.cm, 
          1 => 4.50.cm,
          2 => 1.50.cm,
          3 => 0.80.cm,
          4 => 1.00.cm,
          5 => 1.00.cm,
          6 => 1.50.cm,
          7 => 1.50.cm,
          8 => 1.50.cm,
          9 => 1.50.cm,
          10 => 1.00.cm,
          11 => 1.00.cm,
          12 => 0.90.cm,
          13 => 0.86.cm
        },
        :cell_style => {:padding => 2, :border_width => 0} do |table|
          pdf.dash(5);
          table.column(6..13).style(:align => :right)
          table.column(0..13).border_width = 1
          table.column(0..13).borders = [:bottom]
        end
    end
    
    pdf.page_count.times do |i|
      pdf.go_to_page(i + 1)
      pdf.ibox 1.00, 3.08, 7.71, 5.54, '', 
  	  "FOLHA #{i + 1} de #{pdf.page_count}", {:size => 8, :align => :center, :valign => :center, :border => 0, :style => :bold}
    end
    
    return pdf
      
  end
  
  def self.render(xml_string)  
    xml = XML.new(xml_string)
    pdf = generatePDF(xml)
    return pdf.render
  end
  
  def self.generate(pdf_filename, xml_filename)
    xml = XML.new(File.new(xml_filename))
    pdf = generatePDF(xml)
    pdf.render_file pdf_filename
  end
  
end
