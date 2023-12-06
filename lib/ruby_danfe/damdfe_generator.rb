# coding: utf-8
module RubyDanfe
  class DamdfeGenerator
    def initialize(xml)
      @xml = xml
      @pdf = Document.new
    end

    def generatePDF
      render_cabecalho
      render_titulo
      render_barcode_box
      render_infobox
      render_modal_rodoviario
      render_observacao
      render_relacao_docs_fiscais
      render_footer
      @pdf
    end

    private
    def render_cabecalho
      @pdf.ibox 5, 20, 0.5, 1.25, ' ', @xml['emit/xNome'], { :align => :center, :style => :bold, :size => 14 }
      @pdf.ibox 0.90, 6, 7, 2.25, ' ', "CNPJ:  " + Helper.format_cnpj(@xml['emit/CNPJ']), { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7, 2.25, ' ', "IE:  " + @xml['emit/IE'], { :align => :right, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7, 2.75, ' ', @xml['emit/enderEmit/xLgr'] + "  nº " + @xml['emit/enderEmit/nro'], { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7, 3.25, ' ', @xml['emit/enderEmit/xBairro'], { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7, 3.75, ' ', @xml['emit/enderEmit/xMun'] + " - " + @xml['emit/enderEmit/UF'], { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7, 4.25, ' ', @xml['emit/enderEmit/CEP'][0,4] + "-" + @xml['emit/enderEmit/CEP'][5,7], { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7, 4.75, ' ', Helper.format_fone(@xml['emit/enderEmit/fone']), { :align => :left, :border => 0, :size => 8 }
    end

    def render_titulo
      @pdf.ibox 1.5, 20, 0.5, 6.5, ' ', 'DAMDFE', { :align => :left, :style => :bold, :size => 16 }
      @pdf.ibox 1.5, 16, 2.5, 6.5, ' ', 'Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais', { :align => :center, :style => :bold, :border => 0, :size => 12 }
    end

    def render_barcode_box
      # código de barras
      @pdf.ibox 5, 20, 0.5, 8.25, '', ''
      @pdf.ibox 1, 5, 9.35, 8.4, 'CONTROLE DO FISCO', '', { :border => 0 }
      @pdf.ibarcode 2, 10, 5.5, 10.75, @xml.attrib('infMDFe', 'Id')[4..-1]
      @pdf.ibox 1, 20, 0.5, 11.25, 'CHAVE DE ACESSO', ''
      @pdf.ibox 1, 20, 0.5, 11.5, '', @xml.attrib('infMDFe', 'Id')[4..-1].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "), { :style => :bold, :align => :center, :size => 12, :border => 0 }
      @pdf.ibox 1, 20, 0.5, 12.25, 'PROTOCOLO DE AUTORIZAÇÃO DE USO', '', { :border => 0 }
      @pdf.ibox 1, 20, 0.5, 12.5, '', @xml['infProt/nProt'], { :style => :bold, :align => :center, :border => 0, :size => 8 }
    end

    def render_infobox
      @pdf.ibox 1.5, 2.857142857, 0.5, 13.5, 'MODELO', @xml['ide/mod'], { :size => 10, :align => :center }
      @pdf.ibox 1.5, 2.857142857, 3.357142857, 13.5, 'SERIE', @xml['ide/serie'], { :size => 10, :align => :center }
      @pdf.ibox 1.5, 2.857142857, 6.214285714, 13.5, 'NÚMERO', @xml['ide/nMDF'], { :size => 10, :align => :center }
      @pdf.ibox 1.5, 2.857142857, 9.071428571, 13.5, 'FL', '1/1', { :size => 10, :align => :center }
      @pdf.ibox 1.5, 2.857142857, 11.928571428, 13.5, 'DATA E HORA DE EMISSÃO', Helper.format_datetime(@xml['ide/dhEmi']), { :size => 10, :align => :center }
      @pdf.ibox 1.5, 2.857142857, 14.785714285, 13.5, 'UF CARREG.', @xml['ide/UFIni'], { :size => 10, :align => :center }
      @pdf.ibox 1.5, 2.857142857, 17.642857142, 13.5, 'UF DESCARREG.', @xml['ide/UFFim'], { :size => 10, :align => :center }
    end

    def render_modal_rodoviario
      @pdf.ibox 6, 20, 0.5, 15.25, '', 'Modal Rodoviário de Carga', { :align => :center, :style => :bold, :size => 10 }
      @pdf.ibox 0.8, 4, 0.5, 15.75, 'CIOT', '', { :size => 8, :align => :center }
      @pdf.ibox 0.8, 4, 4.5, 15.75, 'QDT. CT-E', @xml['tot/qCTe'], { :size => 8, :align => :center }
      @pdf.ibox 0.8, 4, 8.5, 15.75, 'QDT. NF-E', '', { :size => 8, :align => :center }
      @pdf.ibox 0.8, 4, 12.5, 15.75, 'PESO TOTAL (KG)', @xml['tot/qCarga'], { :size => 8, :align => :center }
      @pdf.ibox 0.8, 4, 16.5, 15.75, 'VALOR DA MERCADORIA R$', @xml['tot/vCarga'], { :size => 8, :align => :center }


      @pdf.ibox 0.5, 8, 0.5, 16.55, 'VEÍCULO', ''
      @pdf.ibox 1.25, 4, 0.5, 17.05, 'PLACA', Helper.format_car_plate(@xml['veicTracao/placa']), { :size => 8, :align => :center, :border => 0 }
      @pdf.ibox 1.25, 4, 0.5, 18.3, 'RENAVAM', '', { :size => 8, :align => :center }
      @pdf.ibox 2.5, 4, 4.5, 17.05, 'RNTRC', '', { :size => 8, :align => :center }
      @pdf.ibox 0.5, 8, 0.5, 19.55, 'VALE PEDÁGIO', '', { :size => 8, :align => :center }
      @pdf.ibox 1.2, 2.666666667, 0.5, 20.05, 'RESPONSÁVEL CNPJ', '', { :size => 8, :align => :center }
      @pdf.ibox 1.2, 2.666666667, 3.166666667, 20.05, 'FORNECEDOR CNPJ', '', { :size => 8, :align => :center }
      @pdf.ibox 1.2, 2.666666667, 5.833333334, 20.05, 'No COMPROVANTE', '', { :size => 8, :align => :center }
      

      @pdf.ibox 0.5, 12, 8.5, 16.55, 'CONDUTOR', ''
      @pdf.ibox 4.2, 4, 8.5, 17.05, 'CPF', Helper.format_cpf(@xml['condutor/CPF']), { :size => 8, :align => :center }
      @pdf.ibox 4.2, 8, 12.5, 17.05, 'NOME', @xml['condutor/xNome'], { :size => 8, :align => :center }
    end

    def render_observacao
      @pdf.ibox 4, 20, 0.5, 21.5, 'OBSERVAÇÃO'
    end

    def render_relacao_docs_fiscais
      @pdf.ibox 3, 20, 0.5, 25.75, '', 'Relação dos Documentos Fiscais', { :align => :center, :style => :bold, :size => 10 }

      @pdf.ibox 2.5, 10, 0.5, 26.25, 'TP.DOC', 'CTe', { :style => :bold, :align => :left, :size => 8 }
      @pdf.ibox 1.25, 5, 5.5, 26.25, 'CNPJ/CPF EMITENTE', Helper.format_cnpj(@xml['emit/CNPJ']), { :style => :bold, :align => :left, :size => 8, :border => 0 }
      @pdf.ibox 1.25, 10, 0.5, 27.5, 'SÉRIE/NRo DOCUMENTO', @xml['infCTe/chCTe'], { :style => :bold, :align => :left, :size => 8, :border => 0 }
      
      @pdf.ibox 2.5, 10, 10.5, 26.25, 'TP.DOC', '', { :style => :bold, :align => :left, :size => 8 }
      @pdf.ibox 1.25, 5, 15.5, 26.25, 'CNPJ/CPF EMITENTE', '', { :style => :bold, :align => :left, :size => 8, :border => 0 }
      @pdf.ibox 1.25, 10, 10.5, 27.5, 'SÉRIE/NRo DOCUMENTO', '', { :style => :bold, :align => :left, :size => 8, :border => 0 }
    end

    def render_footer
      @pdf.ibox 0.5, 5, 0.5, 29.25, '', "DATA E HORA DA IMPRESSÃO: " + Helper.format_datetime(DateTime.now.to_s), { :size => 6, :align => :left, :border => 0 }
    end
  end
end