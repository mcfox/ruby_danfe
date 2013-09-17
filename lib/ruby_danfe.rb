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

  version = "0.9.3"

  class XML
    def initialize(xml)
      @xml = Nokogiri::XML(xml)
    end
    def [](xpath)
      node = @xml.css(xpath)
      return node ? node.text : ''
    end
    def render
      if @xml.at_css('infNFe/ide')
         RubyDanfe.render @xml.to_s, :danfe
      else
         RubyDanfe.render @xml.to_s, :dacte
      end
    end
    def collect(ns, tag, &block)
      result = []
      # Tenta primeiro com uso de namespace
      begin
        @xml.xpath("//#{ns}:#{tag}").each do |det|
          result << yield(det)
        end
      rescue
        # Caso dê erro, tenta sem
        @xml.xpath("//#{tag}").each do |det|
          result << yield(det)
        end        
      end
      result
    end
    def attrib(node, attrib)
      begin
        return @xml.css(node).attr(attrib).text
      rescue
        ''
      end
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
      self.text_box title, :size => 6, :style => :italic, :at => [at[0] + 2, at[1] - 2], :width => w - 4, :height => 8 if title != ''
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

    x = 0.25
    y = 11.51
    xml.collect('xmlns', 'dup') { |det|
      pdf.ibox 0.85, 2.12, x, y, '', 'Núm.:', { :size => 6, :border => 0, :style => :italic }
      pdf.ibox 0.85, 2.12, x + 0.70, y, '', det.css('nDup').text, { :size => 6, :border => 0 }
      pdf.ibox 0.85, 2.12, x, y + 0.20, '', 'Venc.:', { :size => 6, :border => 0, :style => :italic }
      dtduplicata = det.css('dVenc').text
      dtduplicata = dtduplicata[8,2] + '/' + dtduplicata[5, 2] + '/' + dtduplicata[0, 4]
      pdf.ibox 0.85, 2.12, x + 0.70, y + 0.20, '', dtduplicata, { :size => 6, :border => 0 }
      pdf.ibox 0.85, 2.12, x, y + 0.40, '', 'Valor: R$', { :size => 6, :border => 0, :style => :italic }
      pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.40, '', det.css('vDup').text, { :size => 6, :border => 0 }
      x = x + 2.30
    }
    
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
	
	modFrete = case xml['ide/tpCTe']
		when '0' then '0 - EMITENTE'
        when '1' then '1 - DEST/REMET'
        when '2' then '2 - TERCEIROS'
        when '9' then '9 - SEM FRETE'
        else ''
    end
	
  	pdf.ibox 0.85, 9.02, 0.25, 14.90, "RAZÃO SOCIAL", xml['transporta/xNome']
	pdf.ibox 0.85, 2.79, 9.27, 14.90, "FRETE POR CONTA", modFrete
	pdf.ibox 0.85, 1.78, 12.06, 14.90, "CODIGO ANTT", xml['veicTransp/RNTC']
	pdf.ibox 0.85, 2.29, 13.84, 14.90, "PLACA DO VEÍCULO", xml['veicTransp/placa']
	pdf.ibox 0.85, 0.76, 16.13, 14.90, "UF", xml['veicTransp/UF']
	pdf.ibox 0.85, 3.94, 16.89, 14.90, "CNPJ/CPF", xml['transporta/CNPJ'] 
  	pdf.ibox 0.85, 9.02, 0.25, 15.75, "ENDEREÇO", xml['transporta/xEnder']
  	pdf.ibox 0.85, 6.86, 9.27, 15.75, "MUNICÍPIO", xml['transporta/xMun']
    pdf.ibox 0.85, 0.76, 16.13, 15.75, "UF", xml['transporta/UF']
  	pdf.ibox 0.85, 3.94, 16.89, 15.75, "INSCRIÇÂO ESTADUAL", xml['transporta/IE']

    vol = 0
    xml.collect('xmlns', 'vol') { |det|
      vol += 1
      if vol < 2
        pdf.ibox 0.85, 2.92, 0.25, 16.60, "QUANTIDADE", det.css('qVol').text
        pdf.ibox 0.85, 3.05, 3.17, 16.60, "ESPÉCIE", det.css('esp').text
        pdf.ibox 0.85, 3.05, 6.22, 16.60, "MARCA", det.css('marca').text
        pdf.ibox 0.85, 4.83, 9.27, 16.60, "NUMERAÇÃO"
        pdf.inumeric 0.85, 3.43, 14.10, 16.60, "PESO BRUTO", det.css('pesoB').text, {:decimals => 3}
        pdf.inumeric 0.85, 3.30, 17.53, 16.60, "PESO LÍQUIDO", det.css('pesoL').text, {:decimals => 3}
      else
        break
      end
    }

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

    if vol > 1
      pdf.ibox 3.07, 12.93, 0.25, 26.33, "INFORMAÇÕES COMPLEMENTARES", '', {:size => 8, :valign => :top}
      pdf.ibox 3.07, 12.93, 0.25, 26.60, '', 'CONTINUAÇÃO TRANSPORTADOR/VOLUMES TRANSPORTADOS', {:size => 5, :valign => :top, :border => 0}
      v = 0
      y = 26.67
      xml.collect('xmlns', 'vol') { |det|
        v += 1
        if v > 1
          pdf.ibox 0.35, 0.70, 0.25, y + 0.10, '', 'QUANT.:', { :size => 4, :border => 0 }
          pdf.ibox 0.35, 0.70, 0.90, y + 0.10, '', det.css('qVol').text, { :size => 4, :border => 0, :style => :italic }
          pdf.ibox 0.35, 0.50, 1.35, y + 0.10, '', 'ESP.:', { :size => 4, :border => 0 }
          pdf.ibox 0.35, 3.00, 1.75, y + 0.10, '', det.css('esp').text, { :size => 4, :border => 0, :style => :italic }
          pdf.ibox 0.35, 0.70, 4.15, y + 0.10, '', 'MARCA:', { :size => 4, :border => 0 }
          pdf.ibox 0.35, 2.00, 4.75, y + 0.10, '', det.css('marca').text, { :size => 4, :border => 0, :style => :italic }
          pdf.ibox 0.35, 1.00, 6.10, y + 0.10, '', 'NUM.:',  { :size => 4, :border => 0 }
          pdf.ibox 0.35, 1.30, 7.00, y + 0.10, '', 'PESO B.:', { :size => 4, :border => 0 }
          pdf.inumeric 0.35, 1.30, 7.00, y + 0.10, '', det.css('pesoB').text, {:decimals => 3, :size => 4, :border => 0, :style => :italic }
          pdf.ibox 0.35, 0.90, 8.50, y + 0.10, '', 'PESO LÍQ.:', { :size => 4, :border => 0 }
          pdf.inumeric 0.35, 1.50, 8.50, y + 0.10, '', det.css('pesoL').text, {:decimals => 3, :size => 4, :border => 0, :style => :italic }
          y = y + 0.15
        end
      }
      pdf.ibox 2.07, 12.93, 0.25, y + 0.30, '', 'OUTRAS INFORMAÇÕES', {:size => 6, :valign => :top, :border => 0}
      pdf.ibox 2.07, 12.93, 0.25, y + 0.50, '', xml['infAdic/infCpl'], {:size => 5, :valign => :top, :border => 0}
    else
	     pdf.ibox 3.07, 12.93, 0.25, 26.33, "INFORMAÇÕES COMPLEMENTARES", xml['infAdic/infCpl'], {:size => 6, :valign => :top}
    end
	  
	  pdf.ibox 3.07, 7.62, 13.17, 26.33, "RESERVADO AO FISCO"

    end

    pdf.font_size(6) do
      pdf.itable 6.37, 21.50, 0.25, 18.17, 
        xml.collect('xmlns', 'det')  { |det|
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

  def self.generatePDFDacte(xml)
  
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
      # h, w, x, y, title = '', info = '', options = {}
      # logo

      # emitente
      pdf.ibox 2.27, 7.67, 0.25, 0.54
      pdf.ibox 2.27, 7.67, 0.25, 0.84, '', 
        xml['emit/xNome'],
        { :align => :center, :size => 9, :border => 0, :style => :bold }

      fone = xml['enderEmit/fone']
      unless fone.eql?('')
        if fone.size > 8
          fone =  '(' + xml['enderEmit/fone'][0,2] + ')' + xml['enderEmit/fone'][2,4] + '-' + xml['enderEmit/fone'][6,4]
        else
          fone = xml['enderEmit/fone'][0,4] + '-' + xml['enderEmit/fone'][4,4]
        end
      end
      pdf.ibox 2.27, 7.67, 0.25, 1.30, '',
        xml['enderEmit/xLgr'] + ", " + xml['enderEmit/nro'] + " " + xml['enderEmit/xCpl'] + "\n" +
        xml['enderEmit/xMun'] + " - " + xml['enderEmit/UF'] + " " + xml['enderEmit/xPais'] + "\n" +
        "Fone/Fax: " + fone,
        { :align => :center, :size => 8, :border => 0, :style => :bold }
#      pdf.ibox 2.27, 7.67, 0.25, 1.14, '', xml['enderEmit/xLgr'] + ", " + xml['enderEmit/nro'] + " " + xml['enderEmit/xCpl'], { :align => :center, :size => 8, :border => 0 }
#      pdf.ibox 2.27, 7.67, 0.25, 1.44, '', xml['enderEmit/xBairro'] + " - " + xml['enderEmit/CEP'], { :align => :center, :size => 8, :border => 0 }
#      pdf.ibox 2.27, 7.67, 0.25, 1.74, '', xml['enderEmit/xMun'] + " - " + xml['enderEmit/UF'] + " " + xml['enderEmit/xPais'], { :align => :center, :size => 8, :border => 0 }
#      pdf.ibox 2.27, 7.67, 0.25, 2.04, '', "Fone/Fax: " + xml['enderEmit/fone'], { :align => :center, :size => 8, :border => 0 }
      
      # tipo ct-e
      tpCTe = case xml['ide/tpCTe']
        when '0' then 'Normal'
        when '1' then 'Complemento de Valores'
        when '2' then 'Anulação de Valores'
        when '3' then 'Substituto'
        else ''
      end
      pdf.ibox 0.90, 3.84, 0.25, 2.81, 'TIPO DE CT-E', tpCTe, { :align => :center, :size => 8, :style => :bold }

      # tipo servico
      tpServ = case xml['ide/tpServ']
        when '0' then 'Normal'
        when '1' then 'Subcontratação'
        when '2' then 'Redespacho'
        when '3' then 'Redespacho Intermediário'
        else ''
      end
      pdf.ibox 0.90, 3.83, 4.08, 2.81, 'TIPO DE SERVIÇO', tpServ, { :align => :center, :size => 8, :style => :bold }

      # tomador
      if xml['ide/toma3'] != '' || xml['ide/toma03'] != '' then
        xml['ide/toma3'] != '' ? tomador = 'toma3' : tomador = 'toma03'
      else if xml['ide/toma4'] != '' || xml['ide/toma04'] != '' then
             xml['ide/toma4'] != '' ? tomador = 'toma4' : tomador = 'toma04'
           end
      end
      toma = case xml[tomador + '/toma']
        when '0' then 'Remetente'
        when '1' then 'Expedidor'
        when '2' then 'Recebedor'
        when '3' then 'Destinatário'
        when '4' then 'Outros'
        else ''
      end
      pdf.ibox 0.90, 3.83, 0.25, 3.71, 'TOMADOR DO SERVIÇO', toma, { :align => :center, :size => 8, :style => :bold }

      # sem valor fiscal | ambiente de homolocação

      # forma de pagamento
      forma = case xml['ide/forPag']
        when '0' then 'Pago'
        when '1' then 'A pagar'
        when '2' then 'Outros'
        else ''
      end
      pdf.ibox 0.90, 3.83, 4.08, 3.71, 'FORMA DE PAGAMENTO', forma, { :align => :center, :size => 8, :style => :bold }

      # infobox
      pdf.ibox 0.90, 9.39, 7.92, 0.54, '', 'DACTE', { :align => :center, :style => :bold, :size => 12}
      pdf.ibox 0.90, 9.39, 7.92, 0.94, '', 'Documento auxiliar do Conhecimento de Transporte Eletrônico', { :align => :center, :border => 0, :size => 7 }
      #pdf.ibox 0.90, 9.39, 7.92, 1.04, '', 'de Transporte Eletrônico', { :align => :center, :border => 0, :size => 6 }

      # tipo
      pdf.ibox 0.90, 3.43, 17.31, 0.54, '', 'MODAL', { :align => :center, :size => 7 }

      # modal
      # modal = case xml['ide/modal']
      #   when '1' then 'Rodoviário'
      #   when '2' then 'Aéreo'
      #   when '3' then 'Aquaviário'
      #   when '4' then 'Ferroviário'
      #   when '5' then 'Dutoviário'
      #   else ''
      # end
      pdf.ibox 0.90, 3.43, 17.31, 0.84, '', 'RODOVIÁRIO', { :align => :center, :size => 8, :border => 0, :style => :bold }
      pdf.ibox 0.91, 1.98, 7.92, 1.44, 'MODELO', xml['ide/mod'], {:size => 8, :align => :center}
      pdf.ibox 0.91, 0.75, 9.90, 1.44, 'SERIE', xml['ide/serie'], {:size => 8, :align => :center}
      pdf.ibox 0.91, 2.48, 10.65, 1.44, 'NÚMERO', xml['ide/nCT'], {:size => 8, :align => :center}
      pdf.ibox 0.91, 0.97, 13.13, 1.44, 'FL', '1/1', {:size => 8, :align => :center}
      emiss = xml['ide/dhEmi'][8, 2] + '/' + xml['ide/dhEmi'][5, 2] + '/' + xml['ide/dhEmi'][0, 4] + " " +
        xml['ide/dhEmi'][11, 8]

      pdf.ibox 0.91, 3.21, 14.10, 1.44, 'DATA E HORA DE EMISSÃO', emiss, {:size => 8, :align => :center}
      pdf.ibox 0.91, 3.43, 17.31, 1.44, 'INSC. SUFRAMA DESTINATÁRIO', xml['dest/ISUF'], {:size => 8, :align => :center}
      pdf.ibox 1.13, 12.82, 7.92, 2.35
      pdf.ibarcode 0.85, 12.82, 9.25, 3.35, xml.attrib('infCte', 'Id')[3..-1]
      pdf.ibox 0.62, 12.82, 7.92, 3.48, 'Chave de acesso', ''
      pdf.ibox 0.90, 12.82, 7.92, 3.62, '', xml.attrib('infCte', 'Id')[3..-1].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "), {:style => :bold, :align => :center, :size => 8, :border => 0}
      pdf.ibox 1.13, 12.82, 7.92, 4.10, '', 'Consulta de autenticidade no portal do CT-e, no site da Sefaz Autorizadora, ou em http://www.cte.fazenda.gov.br/portal',
        { :align => :center, :valign => :center, :style => :bold, :size => 8 }
      pdf.ibox 0.71, 12.82, 7.92, 5.23, 'Protocolo de Autorização de Uso'
      pdf.ibox 0.90, 12.82, 7.92, 5.38, '', xml['infProt/nProt'], { :style => :bold, :align => :left, :border => 0, :size => 8 }
      pdf.ibox 1.33, 7.67, 0.25, 4.61, 'CFOP - NATUREZA DA PRESTAÇÃO', xml['ide/CFOP'] + ' - ' + xml['ide/natOp'], { :align => :left, :size => 7, :style => :bold }
      # UFIni -xMunIni
      pdf.ibox 0.92, 10.25, 0.25, 5.94, 'INÍCIO DA PRESTAÇÃO', xml['ide/UFIni'] + ' - ' + xml['ide/xMunIni']
      # UFFim -cMunFim – xMunFim
      pdf.ibox 0.92, 10.24, 10.50, 5.94, 'TÉRMINO DA PRESTAÇÃO', xml['ide/UFFim'] + ' - ' + xml['ide/cMunFim'] + ' - ' + xml['ide/xMunFim']

      # remetente
      pdf.ibox 2.76, 10.25, 0.25, 6.86
      pdf.ibox 0.90, 10.00, 0.28, 7.05, '', 'Remetente: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 1.88, 7.05, '', xml['rem/xNome'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 10.00, 0.28, 7.41, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 1.88, 7.41, '', xml['enderReme/xLgr'] + ', ' + xml['enderReme/nro'] + (xml['enderReme/xCpl'] != '' ? ' - ' + xml['enderReme/xCpl'] : ''), { :size => 7, :border => 0, :style => :bold } if xml['enderReme/xLgr'] != ''
      pdf.ibox 0.90, 5.00, 1.88, 7.68, '', xml['enderReme/xBairro'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 10.00, 0.28, 8.02, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 1.88, 8.02, '', xml['enderReme/xMun'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 3.00, 6.50, 8.02, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 3.00, 7.20, 8.02, '', xml['enderReme/CEP'][0,2] + '.' + xml['enderReme/CEP'][3,3] + '-' + xml['enderReme/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if xml['enderReme/CEP'] != ''
      pdf.ibox 0.90, 10.00, 0.28, 8.41, '', 'CNPJ/CPF: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 1.88, 8.41, '', xml['rem/CNPJ'][0,2] + '.' + xml['rem/CNPJ'][2,3] + '.' + xml['rem/CNPJ'][5,3] + '/' + xml['rem/CNPJ'][8,4] + '-' + xml['rem/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if xml['rem/CNPJ'] != ''
      pdf.ibox 0.90, 10.00, 1.88, 8.41, '', xml['rem/CPF'][0,3] + '.' + xml['rem/CPF'][3,3] + '.' + xml['rem/CPF'][6,3] + '-' + xml['rem/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if xml['rem/CPF'] != ''
      pdf.ibox 0.90, 3.50, 6.50, 8.41, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 3.50, 7.85, 8.41, '', xml['rem/IE'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 6.00, 0.28, 8.82, '', 'UF: ' + '                                     ' + 'País: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 6.00, 1.88, 8.82, '', xml['enderReme/UF'] + '                               ' + xml['enderReme/xPais'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 3.00, 6.50, 8.82, '', 'Fone: ', { :size => 7, :border => 0, :style => :italic }
      fone = xml['rem/fone']
      unless fone.eql?('')
        if fone.size > 8
          pdf.ibox 0.90, 3.00, 7.20, 8.82, '', '(' + xml['rem/fone'][0,2] + ')' + xml['rem/fone'][2,4] + '-' + xml['rem/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          pdf.ibox 0.90, 3.00, 7.20, 8.82, '', xml['rem/fone'][0,4] + '-' + xml['rem/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end

      # destinatário
      pdf.ibox 2.76, 10.24, 10.50, 6.86
      pdf.ibox 0.90, 10.00, 10.53, 7.05, '', 'Destinatário: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 12.10, 7.05, '', xml['dest/xNome'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 10.00, 10.53, 7.41, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 12.10, 7.41, '', xml['enderDest/xLgr'] + ', ' + xml['enderDest/nro'] + (xml['enderDest/xCpl'] != '' ? ' - ' + xml['enderDest/xCpl'] : ''), { :size => 7, :border => 0, :style => :bold } if xml['enderDest/xLgr'] != ''
      pdf.ibox 0.90, 5.00, 12.10, 7.68, '', xml['enderDest/xBairro'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 10.00, 10.53, 8.02, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 12.10, 8.02, '', xml['enderDest/xMun'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 3.00, 16.75, 8.02, '', 'CEP: ' , { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 3.00, 17.40, 8.02, '', xml['enderDest/CEP'][0,2] + '.' + xml['enderDest/CEP'][3,3] + '-' + xml['enderDest/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if xml['enderDest/CEP'] != ''
      pdf.ibox 0.90, 10.00, 10.53, 8.41, '', 'CNPJ/CPF: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 12.10, 8.41, '', xml['dest/CNPJ'][0,2] + '.' + xml['dest/CNPJ'][2,3] + '.' + xml['dest/CNPJ'][5,3] + '/' + xml['dest/CNPJ'][8,4] + '-' + xml['dest/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if xml['dest/CNPJ'] != ''
      pdf.ibox 0.90, 10.00, 12.10, 8.41, '', xml['dest/CPF'][0,3] + '.' + xml['dest/CPF'][3,3] + '.' + xml['dest/CPF'][6,3] + '-' + xml['dest/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if xml['dest/CPF'] != ''
      pdf.ibox 0.90, 3.50, 16.75, 8.41, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 3.50, 18.05, 8.41, '', xml['dest/IE'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 6.00, 10.53, 8.82, '', 'UF: ' + '                                    ' + 'País: ' , { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 6.00, 12.10, 8.82, '', xml['enderDest/UF'] + '                               ' + xml['enderDest/xPais'] , { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 3.00, 16.75, 8.82, '', 'Fone: ', { :size => 7, :border => 0, :style => :italic }
      fone = xml['dest/fone']
      unless fone.eql?('')
        if fone.size > 8
          pdf.ibox 0.90, 3.00, 17.40, 8.82, '', '(' + xml['dest/fone'][0,2] + ')' + xml['dest/fone'][2,4] + '-' + xml['dest/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          pdf.ibox 0.90, 3.00, 17.40, 8.82, '', xml['dest/fone'][0,4] + '-' + xml['dest/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end

      # expedidor
      pdf.ibox 2.76, 10.25, 0.25, 9.62
      pdf.ibox 0.90, 10.00, 0.28, 9.81, '', 'Expedidor: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 1.88, 9.81, '', xml['exped/xNome'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 10.00, 0.28, 10.17, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 1.88, 10.17, '', xml['enderExped/xLgr'] + ', ' + xml['enderExped/nro'] + (xml['enderExped/xCpl'] != '' ? ' - ' + xml['enderExped/xCpl'] : ''), { :size => 7, :border => 0, :style => :bold } if xml['enderExped/xLgr'] != ''
      pdf.ibox 0.90, 5.00, 1.88, 10.44, '', xml['enderExped/xBairro'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 10.00, 0.28, 10.78, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 1.88, 10.78, '', xml['enderExped/xMun'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 3.00, 6.50, 10.78, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 3.00, 7.20, 10.78, '', xml['enderExped/CEP'][0,2] + '.' + xml['enderExped/CEP'][3,3] + '-' + xml['enderExped/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if xml['enderExped/CEP'] != ''
      pdf.ibox 0.90, 10.00, 0.28, 11.17, '', 'CNPJ/CPF: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 1.88, 11.17, '', xml['exped/CNPJ'][0,2] + '.' + xml['exped/CNPJ'][2,3] + '.' + xml['exped/CNPJ'][5,3] + '/' + xml['exped/CNPJ'][8,4] + '-' + xml['exped/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if xml['exped/CNPJ'] != ''
      pdf.ibox 0.90, 10.00, 1.88, 11.17, '', xml['exped/CPF'][0,3] + '.' + xml['exped/CPF'][3,3] + '.' + xml['exped/CPF'][6,3] + '-' + xml['exped/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if xml['exped/CPF'] != ''
      pdf.ibox 0.90, 3.50, 6.50, 11.17, '', 'Inscr. Est.:' , { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 3.50, 7.85, 11.17, '', xml['exped/IE'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 6.00, 0.28, 11.58, '', 'UF: ' + '                                    ' + 'País: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 6.00, 1.88, 11.58, '', xml['enderExped/UF'] + '                               ' + xml['enderExped/xPais'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 3.00, 6.50, 11.58, '', 'Fone: ', { :size => 7, :border => 0, :style => :italic }
      fone = xml['exped/fone']
      unless fone.eql?('')
        if xml['exped/fone'] != '' and fone.size > 8
          pdf.ibox 0.90, 3.00, 7.20, 11.58, '', '(' + xml['exped/fone'][0,2] + ')' + xml['exped/fone'][2,4] + '-' + xml['exped/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          pdf.ibox 0.90, 3.00, 7.20, 11.58, '', xml['exped/fone'][0,4] + '-' + xml['exped/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end

      # recebedor
      pdf.ibox 2.76, 10.24, 10.50, 9.62
      pdf.ibox 0.90, 10.00, 10.53, 9.81, '', 'Recebedor: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 12.10, 9.81, '', xml['receb/xNome'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 10.00, 10.53, 10.17, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 12.10, 10.17, '', xml['enderReceb/xLgr'] + ', ' + xml['enderReceb/nro'] + (xml['enderReceb/xCpl'] != '' ? ' - ' + xml['enderReceb/xCpl'] : ''), { :size => 7, :border => 0, :style => :bold } if xml['enderReceb/xLgr'] != ''
      pdf.ibox 0.90, 5.00, 12.10, 10.44, '', xml['enderReceb/xBairro'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 10.00, 10.53, 10.78, '', 'Município: ' , { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 12.10, 10.78, '', xml['enderReceb/xMun'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 3.00, 16.75, 10.78, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 3.00, 17.40, 10.78, '', xml['enderReceb/CEP'][0,2] + '.' + xml['enderReceb/CEP'][3,3] + '-' + xml['enderReceb/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if xml['enderReceb/CEP'] != ''
      pdf.ibox 0.90, 10.00, 10.53, 11.17, '', 'CNPJ/CPF: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 10.00, 12.10, 11.17, '', xml['receb/CNPJ'][0,2] + '.' + xml['receb/CNPJ'][2,3] + '.' + xml['receb/CNPJ'][5,3] + '/' + xml['receb/CNPJ'][8,4] + '-' + xml['receb/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if xml['receb/CNPJ'] != ''
      pdf.ibox 0.90, 10.00, 12.10, 11.17, '', xml['receb/CPF'][0,3] + '.' + xml['receb/CPF'][3,3] + '.' + xml['receb/CPF'][6,3] + '-' + xml['receb/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if xml['receb/CPF'] != ''
      pdf.ibox 0.90, 3.50, 16.75, 11.17, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 3.50, 18.05, 11.17, '', xml['receb/IE'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 6.00, 10.53, 11.58, '', 'UF: ' + '                                    ' + 'País: ', { :size => 7, :border => 0, :style => :italic }
      pdf.ibox 0.90, 6.00, 12.10, 11.58, '', xml['enderReceb/UF'] + '                               ' + xml['enderReceb/xPais'], { :size => 7, :border => 0, :style => :bold }
      pdf.ibox 0.90, 3.00, 16.75, 11.58, '', 'Fone: ', { :size => 7, :border => 0, :style => :italic }
      fone = xml['receb/fone']
      unless fone.eql?('')
        if xml['receb/fone'] != '' and fone.size > 8
          pdf.ibox 0.90, 3.00, 17.40, 11.58, '', '(' + xml['receb/fone'][0,2] + ')' + xml['receb/fone'][2,4] + '-' + xml['receb/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          pdf.ibox 0.90, 3.00, 17.40, 11.58, '', xml['receb/fone'][0,4] + '-' + xml['receb/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end

      # tomador
      pdf.ibox 1.45, 20.49, 0.25, 12.38
      if xml['ide/toma3'] != '' || xml['ide/toma03'] != '' then
        xml['ide/toma3'] != '' ? tomador = 'toma3' : tomador = 'toma03'
      else if xml['ide/toma4'] != '' || xml['ide/toma04'] != '' then
             xml['ide/toma4'] != '' ? tomador = 'toma4' : tomador = 'toma04'
           end
      end
      toma = case xml[tomador + '/toma']
               when '0' then 'rem'
               when '1' then 'exped'
               when '2' then 'receb'
               when '3' then 'dest'
               when '4' then 'Outros'
               else ''
             end
      endereco = case xml[tomador + '/toma']
                     when '0' then 'enderReme'
                     when '1' then 'enderExped'
                     when '2' then 'enderReceb'
                     when '3' then 'enderDest'
                     when '4' then 'Outros'
                     else ''
                   end
      if toma == 'Outros'
        pdf.ibox 0.90, 10.00, 0.28, 12.45, '', 'Tomador do Serviço: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 10.00, 2.58, 12.45, '', xml['toma4/xNome'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 10.00, 10.50, 12.45, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 10.00, 11.80, 12.45, '', xml['enderToma/xMun'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 4.00, 18.00, 12.45, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 4.00, 18.70, 12.45, '', xml['enderToma/CEP'][0,2] + '.' + xml['enderToma/CEP'][3,3] + '-' + xml['enderToma/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if xml['enderToma/CEP'] != ''
        pdf.ibox 0.90, 10.00, 0.28, 12.81, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 10.00, 1.88, 12.81, '', xml['enderToma/xLgr'] + ', ' + xml['enderToma/nro'] + (xml['enderToma/xCpl'] != '' ? ' - ' + xml['enderToma/xCpl'] : '') + ' - ' + xml['enderToma/xBairro'], { :size => 7, :border => 0, :style => :bold } if xml['enderToma/xLgr'] != ''
        pdf.ibox 0.90, 2.00, 13.50, 12.81, '', 'UF: ' , { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 2.00, 14.50, 12.81, '', xml['enderToma/UF'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 5.00, 16.50, 12.81, '', 'País: ' , { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 5.00, 17.50, 12.81, '', xml['enderToma/xPais'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 5.00, 0.28, 13.17, '', 'CNPJ/CPF: ' , { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 5.00, 1.88, 13.17, '', xml['toma4/CNPJ'][0,2] + '.' + xml['toma4/CNPJ'][2,3] + '.' + xml['toma4/CNPJ'][5,3] + '/' + xml['toma4/CNPJ'][8,4] + '-' + xml['toma4/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if xml['toma4/CNPJ'] != ''
        pdf.ibox 0.90, 5.00, 1.88, 13.17, '', xml['toma4/CPF'][0,3] + '.' + xml['toma4/CPF'][3,3] + '.' + xml['toma4/CPF'][6,3] + '-' + xml['toma4/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if xml['toma4/CPF'] != ''
        pdf.ibox 0.90, 5.00, 5.60, 13.17, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 5.00, 7.20, 13.17, '', xml['toma4/IE'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 5.00, 10.50, 13.17, '', 'Fone: ' , { :size => 7, :border => 0, :style => :italic }
        fone = xml['toma4/fone']
        unless fone.eql?('')
          if fone.size > 8
            pdf.ibox 0.90, 5.00, 11.80, 13.17, '', '(' + xml['toma4/fone'][0,2] + ')' + xml['toma4/fone'][2,4] + '-' + xml['toma4/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
          else
            pdf.ibox 0.90, 5.00, 11.80, 13.17, '', xml['toma4/fone'][0,4] + '-' + xml['toma4/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
          end
        end
      else
        pdf.ibox 0.90, 10.00, 0.28, 12.45, '', 'Tomador do Serviço: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 10.00, 2.58, 12.45, '', xml[toma + '/xNome'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 10.00, 10.50, 12.45, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 10.00, 11.80, 12.45, '', xml[endereco + '/xMun'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 4.00, 18.00, 12.45, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 4.00, 18.70, 12.45, '', xml[endereco + '/CEP'][0,2] + '.' + xml[endereco + '/CEP'][3,3] + '-' + xml[endereco + '/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if xml[endereco + '/CEP'] != ''
        pdf.ibox 0.90, 10.00, 0.28, 12.81, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 10.00, 1.88, 12.81, '', xml[endereco + '/xLgr'] + ', ' + xml[endereco + '/nro'] + (xml[endereco + '/xCpl'] != '' ? ' - ' + xml[endereco + '/xCpl'] : '') + ' - ' + xml[endereco + '/xBairro'], { :size => 7, :border => 0, :style => :bold } if xml[endereco + '/xLgr'] != ''
        pdf.ibox 0.90, 2.00, 13.50, 12.81, '', 'UF: ' , { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 2.00, 14.50, 12.81, '', xml[endereco + '/UF'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 5.00, 16.50, 12.81, '', 'País: ' , { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 5.00, 17.50, 12.81, '', xml[endereco + '/xPais'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 5.00, 0.28, 13.17, '', 'CNPJ/CPF: ' , { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 5.00, 1.88, 13.17, '', xml[toma + '/CNPJ'][0,2] + '.' + xml[toma + '/CNPJ'][2,3] + '.' + xml[toma + '/CNPJ'][5,3] + '/' + xml[toma + '/CNPJ'][8,4] + '-' + xml[toma + '/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if xml[toma + '/CNPJ'] != ''
        pdf.ibox 0.90, 5.00, 1.88, 13.17, '', xml[toma + '/CPF'][0,3] + '.' + xml[toma + '/CPF'][3,3] + '.' + xml[toma + '/CPF'][6,3] + '-' + xml[toma + '/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if xml[toma + '/CPF'] != ''
        pdf.ibox 0.90, 5.00, 5.60, 13.17, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
        pdf.ibox 0.90, 5.00, 7.20, 13.17, '', xml[toma + '/IE'], { :size => 7, :border => 0, :style => :bold }
        pdf.ibox 0.90, 5.00, 10.50, 13.17, '', 'Fone: ' , { :size => 7, :border => 0, :style => :italic }
        fone =  xml[toma + '/fone']
        unless fone.eql?('')
          if fone.size > 8
            pdf.ibox 0.90, 5.00, 11.80, 13.17, '', '(' + xml[toma + '/fone'][0,2] + ')' + xml[toma + '/fone'][2,4] + '-' + xml[toma + '/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
          else
            pdf.ibox 0.90, 5.00, 11.80, 13.17, '', xml[toma + '/fone'][0,4] + '-' + xml[toma + '/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
          end
        end
      end

      #produto predominante/outras caract, valor total
      #pdf.ibox 0.92, 20.49, 0.25, 13.82
      pdf.ibox 0.90, 6.83, 0.25, 13.82, 'PRODUTO PREDOMINANTE', xml['infCarga/proPred'], {:size => 7, :style => :bold }
      pdf.ibox 0.90, 6.83, 7.09, 13.82, 'OUTRAS CARACTERÍSTICAS DA CARGA', xml['infCarga/xOutCat'], {:size => 7, :style => :bold }
      pdf.ibox 0.90, 6.82, 13.92, 13.82, 'VALOR TOTAL DA MERCADORIA', '0,00', {:size => 7, :style => :bold }

      #quantidade carga
      pdf.ibox 0.90, 1.07, 0.25, 14.72, '', 'QTD.', { :size => 7, :align => :center, :style => :italic}
      pdf.ibox 0.90, 1.07, 0.25, 15.02, '', 'CARGA', { :size => 7, :align => :center, :style => :italic, :border => 0}
      pdf.ibox 0.90, 3.50, 1.33, 14.72, 'QT./UN. MEDIDA', '', { :size => 7, :style => :italic }
      pdf.ibox 0.90, 3.50, 4.83, 14.72, 'QT./UN. MEDIDA', '', { :size => 7, :style => :italic }
      pdf.ibox 0.90, 3.50, 8.33, 14.72, 'QT./UN. MEDIDA', '', { :size => 7, :style => :italic }
      x = 1.33
      xml.collect('xmlns', 'infQ') { |det|
        if !det.css('cUnid').text.eql?('00')
           pdf.ibox 0.90, 3.50, x, 15.02, '', det.css('qCarga').text, { :size => 7, :style => :bold, :border => 0 }
           x = x + 3.50
        end
      }

      #seguradora
      respons = case xml['seg/respSeg']
         when '0' then 'Remetente'
         when '1' then 'Expedidor'
         when '2' then 'Recebedor'
         when '3' then 'Destinatário'
         when '4' then 'Emitente do CT-e'
         when '5' then 'Tomador de Serviço'
        else ''
      end
      pdf.ibox 0.30, 8.91, 11.83, 14.72, 'Nome da Seguradora: ' + xml['seg/xSeg'], '', {:size => 7}
      pdf.ibox 0.60, 3.70, 11.83, 15.02, '', 'Responsável: ' + respons, {:size => 6}
      pdf.ibox 0.60, 2.50, 15.52, 15.02, '', 'Nº Apólice: ' + xml['seg/nApol'], { :size => 6}
      pdf.ibox 0.60, 2.73, 18.01, 15.02, '', 'Nº Averbação: ' + xml['seg/nAver'], { :size => 6}

      #componentes do valor da prestação de serviço
      pdf.ibox 0.40, 20.49, 0.25, 15.63, '', 'COMPONENTES DO VALOR DA PRESTAÇÃO DE SERVIÇO', { :align => :left, :size => 7, :style => :bold, :border => 0}
      pdf.ibox 1.40, 4.00, 0.25, 16.03
      pdf.ibox 1.40, 2.12, 0.25, 16.02, 'NOME', '', { :size => 7, :border => 0 }
      pdf.ibox 1.40, 1.88, 3.05, 16.02, 'VALOR', '', { :size => 7, :border => 0 }
      pdf.ibox 1.40, 4.00, 4.26, 16.03
      pdf.ibox 1.40, 2.12, 4.26, 16.02, 'NOME', '', { :size => 7, :border => 0 }
      pdf.ibox 1.40, 1.88, 7.14, 16.02, 'VALOR', '', { :size => 7, :border => 0 }
      pdf.ibox 1.40, 4.00, 8.25, 16.03
      pdf.ibox 1.40, 2.12, 8.25, 16.02, 'NOME', '', { :size => 7, :border => 0 }
      pdf.ibox 1.40, 1.88, 11.05, 16.02, 'VALOR', '', { :size => 7, :border => 0 }
      pdf.ibox 1.40, 4.00, 12.26, 16.03
      pdf.ibox 1.40, 2.12, 12.26, 16.02, 'NOME', '', { :size => 7, :border => 0 }
      pdf.ibox 1.40, 1.88, 15.05, 16.02, 'VALOR', '',{ :size => 7, :border => 0 }
      x = 0.25
      y = 16.40
      xml.collect('xmlns', 'Comp') { |det|
        pdf.ibox 1.40, 2.12, x, y, '', det.css('xNome').text, { :size => 6, :border => 0, :style => :bold }
        pdf.inumeric 1.40, 1.88, x + 1.80, y, '', det.css('vComp').text, { :size => 7, :border => 0, :align => :right, :style => :bold }
        y = y + 0.40
        if y > 16.80
           x = x + 4.00
           y = 16.40
        end
      }
      pdf.ibox 0.70, 4.48, 16.26, 16.03
      pdf.inumeric 0.70, 4.48, 16.26, 16.03, 'VALOR TOTAL DO SERVIÇO', xml['vPrest/vTPrest'], { :align => :center, :size => 6, :style => :bold}
      pdf.inumeric 0.70, 4.48, 16.26, 16.73, 'VALOR A RECEBER', xml['vPrest/vRec'],{ :align => :center, :size => 6, :style => :bold }

      #informações relativas ao Imposto
      pdf.ibox 0.40, 20.49, 0.25, 17.42, '', 'INFORMAÇÕES RELATIVAS AO IMPOSTO', { :align => :left, :size => 7, :border => 0, :style => :bold }
      if !xml['imp/ICMS/ICMS00'].eql?("")
         cst = '00 - Tributação Normal ICMS'
         tipoIcms = 'ICMS00'
      elsif !xml['imp/ICMS/ICMS20'].eql?("")
         cst = '20 - Tributação com BC reduzida do ICMS'
         tipoIcms = 'ICMS20'
      elsif !xml['imp/ICMS/ICMS45'].eql?("")
         cst = '40 - ICMS Isenção;  41 - ICMS não tributada;  51 - ICMS diferido'
         tipoIcms = 'ICMS45'
      elsif !xml['imp/ICMS/ICMS60'].eql?("")
         cst = '60 - ICMS cobrado anteriormente por Substituição Tributária'
         tipoIcms = 'ICMS60'
      elsif !xml['imp/ICMS/ICMS90'].eql?("")
         cst = '90 - ICMS outros'
         tipoIcms = 'ICMS90'
      elsif !xml['imp/ICMS/ICMSSN'].eql?("")
         cst = 'Simples Nacional'
         tipoIcms = 'ICMSSN'
      else
        cst = '90 - ICMS outros'
        tipoIcms = 'ICMSOutraUF'
      end 
      pdf.ibox 0.90, 10.00, 0.25, 17.83, 'SITUAÇÃO TRIBUTÁRIA', cst, { :size => 7, :style => :bold }
      pdf.inumeric 0.90, 3.00, 10.25, 17.83, 'BASE DE CÁLCULO', xml['imp/ICMS/'+ tipoIcms + '/vBC'], { :size => 7, :style => :bold }
      pdf.inumeric 0.90, 1.00, 13.25, 17.83, 'AL. ICMS', xml[('imp/ICMS/' + tipoIcms + '/pICMS')], { :size => 7, :style => :bold }
      pdf.inumeric 0.90, 3.00, 14.25, 17.83, 'VALOR ICMS', xml['imp/ICMS/' +  tipoIcms + '/vICMS'],{ :size => 7, :style => :bold }
      pdf.inumeric 0.90, 2.00, 17.25, 17.83, '% RED.BC.CALC.', xml['imp/ICMS/' + tipoIcms + '/pRedBC'], { :size => 7, :style => :bold }
      pdf.inumeric 0.90, 1.49, 19.25, 17.83, 'ICMS ST.', xml['imp/ICMS/' + tipoIcms + '/pRedBC'], { :size => 7, :style => :bold }

      #documentos originários
      pdf.ibox 0.40, 20.49, 0.25, 18.73, '', 'DOCUMENTOS ORIGINÁRIOS', { :align => :left, :size => 7, :style => :bold, :border => 0 }
      pdf.ibox 5.52, 2.25, 0.25, 19.13, 'TP DOC.', '', { :size => 7}
      pdf.ibox 5.52, 4.00, 2.50, 19.13, 'CNPJ/CPF EMITENTE', '', { :size => 7}
      pdf.ibox 5.52, 1.50, 6.50, 19.13, 'SÉRIE', '', { :size => 7}
      pdf.ibox 5.52, 2.50, 8.00, 19.13, 'Nº DOCUMENTO', '', { :size => 7}
      pdf.ibox 5.52, 2.25, 10.50, 19.13, 'TP DOC.', '', { :size => 7}
      pdf.ibox 5.52, 4.00, 12.75, 19.13, 'CNPJ/CPF EMITENTE', '', { :size => 7}
      pdf.ibox 5.52, 1.50, 16.75, 19.13, 'SÉRIE', '', { :size => 7}
      pdf.ibox 5.52, 2.50, 18.24, 19.13, 'Nº DOCUMENTO', '', { :size => 7}
      x = 0.25
      xml.collect('xmlns', 'infNF') { |det|
        pdf.ibox 5.52, 2.25, x, 19.43, '', det.css('mod').text, { :size => 7, :border => 0, :style => :bold }
        x = x + 2.25
        pdf.ibox 5.52, 2.25, x, 19.43, '', xml['rem/CNPJ'][0,2] + '.' + xml['rem/CNPJ'][2,3] + '.' +xml['rem/CNPJ'][5,3] + '/' + xml['rem/CNPJ'][8,4] + '-' + xml['rem/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if xml['rem/CNPJ'] != ''
        pdf.ibox 5.52, 2.25, x, 19.43, '', xml['rem/CPF'][0,3] + '.' + xml['rem/CPF'][3,3] + '.' +xml['rem/CPF'][6,3] + '-' + xml['rem/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if xml['rem/CPF'] != ''
        x = x + 4.00
        pdf.ibox 5.52, 2.25, x, 19.43, '', det.css('serie').text, { :size => 7, :border => 0, :style => :bold }
        x = x + 1.50
        pdf.ibox 5.52, 2.25, x, 19.43, '', det.css('nDoc').text, { :size => 7, :border => 0, :style => :bold }
        x = x + 2.50
      }

      #OBSERVAÇÕES
      pdf.ibox 0.40, 20.49, 0.25, 24.65, '', 'OBSERVAÇÕES', { :align => :left, :size => 7, :style => :bold, :border => 0 }
      pdf.ibox 1.40, 20.49, 0.25, 25.05, '', (xml['compl/xObs'] + "\n CTe COMPLEMENTADO " + "Chave: " + xml['infCteComp/chave'] + " Valor de serviço: " +
      numerify(xml['vPresComp/vTPrest']).to_s ), { :align => :left, :size => 7 }

      #informações do modal
      pdf.ibox 0.40, 20.49, 0.25, 26.45, '', 'INFORMAÇÕES ESPECÍFICAS DO MODAL RODOVIÁRIO - CARGA FRACIONADA', { :align => :left, :size => 7, :style => :bold, :border => 0}
      pdf.ibox 0.90, 3.00, 0.25, 26.85, 'RNTRC DA EMPRESA', xml['rodo/RNTRC'], { :size => 7, :style => :bold }
      pdf.ibox 0.90, 3.00, 3.25, 26.85, 'CIOT', xml['rodo/CIOT'], { :size => 7, :style => :bold }

      dtentrega = xml['rodo/dPrev'][8, 2].to_s + '/' + xml['rodo/dPrev'][5, 2].to_s + '/' + xml['rodo/dPrev'][0, 4].to_s

      pdf.ibox 0.90, 4.00, 6.25, 26.85, 'DATA PREVISTA DE ENTREGA', dtentrega, { :size => 7, :style => :bold }
      pdf.ibox 0.90, 10.49, 10.25, 26.85, '', 'ESTE CONHECIMENTO DE TRANSPORTE ATENDE A LEGISLAÇÃO DE TRANSPORTE RODOVIÁRIO EM VIGOR', { :size => 5, :align => :center }

      #informações do modal
      pdf.ibox 0.40, 15.49, 0.25, 27.75, '', 'USO EXCLUSIVO DO EMISSOR DO CT-e', { :align => :center, :size => 7 }
      pdf.ibox 1.20, 15.49, 0.25, 28.15, '', '', { :align => :center, :size => 6 }
      pdf.ibox 0.40, 5.00, 15.74, 27.75, '', 'RESERVADO AO FISCO', { :align => :center, :size => 7 }
      pdf.ibox 1.20, 5.00, 15.74, 28.15, '', '', { :align => :center, :size => 6 }

    end

    return pdf
  end
  
  def self.render(xml_string, type = :danfe)  
    xml = XML.new(xml_string)
    pdf = if type == :danfe 
            generatePDF(xml)
          elsif type == :dacte
            generatePDFDacte(xml)
          end
    return pdf.render
  end
  
  def self.generate(pdf_filename, xml_filename, type = :danfe)
    xml = XML.new(File.new(xml_filename))
    pdf = if type == :danfe
            generatePDF(xml)
          elsif type == :dacte
            generatePDFDacte(xml)
          end
    pdf.render_file pdf_filename
  end

  def self.render_file(pdf_filename, xml_string, type = :danfe)
    xml = XML.new(xml_string)
    pdf = if type == :danfe 
            generatePDF(xml)
          elsif type == :dacte
            generatePDFDacte(xml)
          end
    pdf.render_file pdf_filename
  end

end
