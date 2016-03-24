# coding: utf-8
module RubyDanfe
  class DacteGenerator
    def initialize(xml)
      @xml = xml
      @pdf = Document.new
    end

    def generatePDF
      @pdf.repeat :all do
        render_emitente
        render_tipo_cte
        render_tipo_servico
        render_tomador
        render_forma_de_pagamento
        render_infobox
        render_remetente
        render_destinatario
        render_expedidor
        render_recebedor
        render_tomador_do_servico
        render_produto
        render_quantidade
        render_seguradora
        render_valor_da_prestacao
        render_impostos
        render_documentos_originarios
        render_observacoes
        render_modal
      end

      @pdf
    end

    private
    def render_emitente
      @pdf.ibox 2.27, 7.67, 0.25, 0.54
      @pdf.ibox 2.27, 7.67, 0.25, 0.84, '',
        @xml['emit/xNome'],
        { :align => :center, :size => 9, :border => 0, :style => :bold }

      fone = @xml['enderEmit/fone']
      unless fone.eql?('')
        if fone.size > 8
          fone =  '(' + @xml['enderEmit/fone'][0,2] + ')' + @xml['enderEmit/fone'][2,4] + '-' + @xml['enderEmit/fone'][6,4]
        else
          fone = @xml['enderEmit/fone'][0,4] + '-' + @xml['enderEmit/fone'][4,4]
        end
      end
      @pdf.ibox 2.27, 7.67, 0.25, 1.30, '',
        @xml['enderEmit/xLgr'] + ", " + @xml['enderEmit/nro'] + " " + @xml['enderEmit/xCpl'] + "\n" +
        @xml['enderEmit/xMun'] + " - " + @xml['enderEmit/UF'] + " " + @xml['enderEmit/xPais'] + "\n" +
        "Fone/Fax: " + fone,
        { :align => :center, :size => 8, :border => 0, :style => :bold }
    end

    def render_tipo_cte
      # tipo ct-e
      tpCTe = case @xml['ide/tpCTe']
        when '0' then 'Normal'
        when '1' then 'Complemento de Valores'
        when '2' then 'Anulação de Valores'
        when '3' then 'Substituto'
        else ''
      end
      @pdf.ibox 0.90, 3.84, 0.25, 2.81, 'TIPO DE CT-E', tpCTe, { :align => :center, :size => 8, :style => :bold }
    end

    def render_tipo_servico
      # tipo servico
      tpServ = case @xml['ide/tpServ']
        when '0' then 'Normal'
        when '1' then 'Subcontratação'
        when '2' then 'Redespacho'
        when '3' then 'Redespacho Intermediário'
        else ''
      end
      @pdf.ibox 0.90, 3.83, 4.08, 2.81, 'TIPO DE SERVIÇO', tpServ, { :align => :center, :size => 8, :style => :bold }
    end

    def render_tomador
      # tomador
      if @xml['ide/toma3'] != '' || @xml['ide/toma03'] != '' then
        @xml['ide/toma3'] != '' ? tomador = 'toma3' : tomador = 'toma03'
      else if @xml['ide/toma4'] != '' || @xml['ide/toma04'] != '' then
             @xml['ide/toma4'] != '' ? tomador = 'toma4' : tomador = 'toma04'
           end
      end
      toma = case @xml[tomador + '/toma']
        when '0' then 'Remetente'
        when '1' then 'Expedidor'
        when '2' then 'Recebedor'
        when '3' then 'Destinatário'
        when '4' then 'Outros'
        else ''
      end
      @pdf.ibox 0.90, 3.83, 0.25, 3.71, 'TOMADOR DO SERVIÇO', toma, { :align => :center, :size => 8, :style => :bold }
    end

    def render_forma_de_pagamento
      # forma de pagamento
      forma = case @xml['ide/forPag']
        when '0' then 'Pago'
        when '1' then 'A pagar'
        when '2' then 'Outros'
        else ''
      end
      @pdf.ibox 0.90, 3.83, 4.08, 3.71, 'FORMA DE PAGAMENTO', forma, { :align => :center, :size => 8, :style => :bold }
    end

    def render_infobox
      # infobox
      @pdf.ibox 0.90, 9.39, 7.92, 0.54, '', 'DACTE', { :align => :center, :style => :bold, :size => 12}
      @pdf.ibox 0.90, 9.39, 7.92, 0.94, '', 'Documento auxiliar do Conhecimento de Transporte Eletrônico', { :align => :center, :border => 0, :size => 7 }
      #@pdf.ibox 0.90, 9.39, 7.92, 1.04, '', 'de Transporte Eletrônico', { :align => :center, :border => 0, :size => 6 }

      # tipo
      @pdf.ibox 0.90, 3.43, 17.31, 0.54, '', 'MODAL', { :align => :center, :size => 7 }

      # modal
      # modal = case @xml['ide/modal']
      #   when '1' then 'Rodoviário'
      #   when '2' then 'Aéreo'
      #   when '3' then 'Aquaviário'
      #   when '4' then 'Ferroviário'
      #   when '5' then 'Dutoviário'
      #   else ''
      # end
      @pdf.ibox 0.90, 3.43, 17.31, 0.84, '', 'RODOVIÁRIO', { :align => :center, :size => 8, :border => 0, :style => :bold }
      @pdf.ibox 0.91, 1.98, 7.92, 1.44, 'MODELO', @xml['ide/mod'], {:size => 8, :align => :center}
      @pdf.ibox 0.91, 0.75, 9.90, 1.44, 'SERIE', @xml['ide/serie'], {:size => 8, :align => :center}
      @pdf.ibox 0.91, 2.48, 10.65, 1.44, 'NÚMERO', @xml['ide/nCT'], {:size => 8, :align => :center}
      @pdf.ibox 0.91, 0.97, 13.13, 1.44, 'FL', '1/1', {:size => 8, :align => :center}
      emiss = @xml['ide/dhEmi'][8, 2] + '/' + @xml['ide/dhEmi'][5, 2] + '/' + @xml['ide/dhEmi'][0, 4] + " " +
        @xml['ide/dhEmi'][11, 8]

      @pdf.ibox 0.91, 3.21, 14.10, 1.44, 'DATA E HORA DE EMISSÃO', emiss, {:size => 8, :align => :center}
      @pdf.ibox 0.91, 3.43, 17.31, 1.44, 'INSC. SUFRAMA DESTINATÁRIO', @xml['dest/ISUF'], {:size => 8, :align => :center}
      @pdf.ibox 1.13, 12.82, 7.92, 2.35
      @pdf.ibarcode 0.85, 12.82, 9.25, 3.35, @xml.attrib('infCte', 'Id')[3..-1]
      @pdf.ibox 0.62, 12.82, 7.92, 3.48, 'Chave de acesso', ''
      @pdf.ibox 0.90, 12.82, 7.92, 3.62, '', @xml.attrib('infCte', 'Id')[3..-1].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "), {:style => :bold, :align => :center, :size => 8, :border => 0}
      @pdf.ibox 1.13, 12.82, 7.92, 4.10, '', 'Consulta de autenticidade no portal do CT-e, no site da Sefaz Autorizadora, ou em http://www.cte.fazenda.gov.br/portal',
        { :align => :center, :valign => :center, :style => :bold, :size => 8 }
      @pdf.ibox 0.71, 12.82, 7.92, 5.23, 'Protocolo de Autorização de Uso'
      @pdf.ibox 0.90, 12.82, 7.92, 5.38, '', @xml['infProt/nProt'], { :style => :bold, :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 1.33, 7.67, 0.25, 4.61, 'CFOP - NATUREZA DA PRESTAÇÃO', @xml['ide/CFOP'] + ' - ' + @xml['ide/natOp'], { :align => :left, :size => 7, :style => :bold }
      # UFIni -xMunIni
      @pdf.ibox 0.92, 10.25, 0.25, 5.94, 'INÍCIO DA PRESTAÇÃO', @xml['ide/UFIni'] + ' - ' + @xml['ide/xMunIni']
      # UFFim -cMunFim – xMunFim
      @pdf.ibox 0.92, 10.24, 10.50, 5.94, 'TÉRMINO DA PRESTAÇÃO', @xml['ide/UFFim'] + ' - ' + @xml['ide/cMunFim'] + ' - ' + @xml['ide/xMunFim']
    end

    def render_remetente
      # remetente
      @pdf.ibox 2.76, 10.25, 0.25, 6.86
      @pdf.ibox 0.90, 10.00, 0.28, 7.05, '', 'Remetente: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 1.88, 7.05, '', @xml['rem/xNome'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 10.00, 0.28, 7.41, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 1.88, 7.41, '', @xml['enderReme/xLgr'] + ', ' + @xml['enderReme/nro'] + (@xml['enderReme/xCpl'] != '' ? ' - ' + @xml['enderReme/xCpl'] : ''), { :size => 7, :border => 0, :style => :bold } if @xml['enderReme/xLgr'] != ''
      @pdf.ibox 0.90, 5.00, 1.88, 7.68, '', @xml['enderReme/xBairro'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 10.00, 0.28, 8.02, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 1.88, 8.02, '', @xml['enderReme/xMun'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 3.00, 6.50, 8.02, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 3.00, 7.20, 8.02, '', @xml['enderReme/CEP'][0,2] + '.' + @xml['enderReme/CEP'][3,3] + '-' + @xml['enderReme/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if @xml['enderReme/CEP'] != ''
      @pdf.ibox 0.90, 10.00, 0.28, 8.41, '', 'CNPJ/CPF: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 1.88, 8.41, '', @xml['rem/CNPJ'][0,2] + '.' + @xml['rem/CNPJ'][2,3] + '.' + @xml['rem/CNPJ'][5,3] + '/' + @xml['rem/CNPJ'][8,4] + '-' + @xml['rem/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if @xml['rem/CNPJ'] != ''
      @pdf.ibox 0.90, 10.00, 1.88, 8.41, '', @xml['rem/CPF'][0,3] + '.' + @xml['rem/CPF'][3,3] + '.' + @xml['rem/CPF'][6,3] + '-' + @xml['rem/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if @xml['rem/CPF'] != ''
      @pdf.ibox 0.90, 3.50, 6.50, 8.41, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 3.50, 7.85, 8.41, '', @xml['rem/IE'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 6.00, 0.28, 8.82, '', 'UF: ' + '                                     ' + 'País: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 6.00, 1.88, 8.82, '', @xml['enderReme/UF'] + '                               ' + @xml['enderReme/xPais'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 3.00, 6.50, 8.82, '', 'Fone: ', { :size => 7, :border => 0, :style => :italic }
      fone = @xml['rem/fone']
      unless fone.eql?('')
        if fone.size > 8
          @pdf.ibox 0.90, 3.00, 7.20, 8.82, '', '(' + @xml['rem/fone'][0,2] + ')' + @xml['rem/fone'][2,4] + '-' + @xml['rem/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          @pdf.ibox 0.90, 3.00, 7.20, 8.82, '', @xml['rem/fone'][0,4] + '-' + @xml['rem/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end
    end

    def render_destinatario
      # destinatário
      @pdf.ibox 2.76, 10.24, 10.50, 6.86
      @pdf.ibox 0.90, 10.00, 10.53, 7.05, '', 'Destinatário: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 12.10, 7.05, '', @xml['dest/xNome'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 10.00, 10.53, 7.41, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 12.10, 7.41, '', @xml['enderDest/xLgr'] + ', ' + @xml['enderDest/nro'] + (@xml['enderDest/xCpl'] != '' ? ' - ' + @xml['enderDest/xCpl'] : ''), { :size => 7, :border => 0, :style => :bold } if @xml['enderDest/xLgr'] != ''
      @pdf.ibox 0.90, 5.00, 12.10, 7.68, '', @xml['enderDest/xBairro'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 10.00, 10.53, 8.02, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 12.10, 8.02, '', @xml['enderDest/xMun'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 3.00, 16.75, 8.02, '', 'CEP: ' , { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 3.00, 17.40, 8.02, '', @xml['enderDest/CEP'][0,2] + '.' + @xml['enderDest/CEP'][3,3] + '-' + @xml['enderDest/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if @xml['enderDest/CEP'] != ''
      @pdf.ibox 0.90, 10.00, 10.53, 8.41, '', 'CNPJ/CPF: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 12.10, 8.41, '', @xml['dest/CNPJ'][0,2] + '.' + @xml['dest/CNPJ'][2,3] + '.' + @xml['dest/CNPJ'][5,3] + '/' + @xml['dest/CNPJ'][8,4] + '-' + @xml['dest/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if @xml['dest/CNPJ'] != ''
      @pdf.ibox 0.90, 10.00, 12.10, 8.41, '', @xml['dest/CPF'][0,3] + '.' + @xml['dest/CPF'][3,3] + '.' + @xml['dest/CPF'][6,3] + '-' + @xml['dest/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if @xml['dest/CPF'] != ''
      @pdf.ibox 0.90, 3.50, 16.75, 8.41, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 3.50, 18.05, 8.41, '', @xml['dest/IE'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 6.00, 10.53, 8.82, '', 'UF: ' + '                                    ' + 'País: ' , { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 6.00, 12.10, 8.82, '', @xml['enderDest/UF'] + '                               ' + @xml['enderDest/xPais'] , { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 3.00, 16.75, 8.82, '', 'Fone: ', { :size => 7, :border => 0, :style => :italic }
      fone = @xml['dest/fone']
      unless fone.eql?('')
        if fone.size > 8
          @pdf.ibox 0.90, 3.00, 17.40, 8.82, '', '(' + @xml['dest/fone'][0,2] + ')' + @xml['dest/fone'][2,4] + '-' + @xml['dest/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          @pdf.ibox 0.90, 3.00, 17.40, 8.82, '', @xml['dest/fone'][0,4] + '-' + @xml['dest/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end
    end

    def render_expedidor
      # expedidor
      @pdf.ibox 2.76, 10.25, 0.25, 9.62
      @pdf.ibox 0.90, 10.00, 0.28, 9.81, '', 'Expedidor: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 1.88, 9.81, '', @xml['exped/xNome'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 10.00, 0.28, 10.17, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 1.88, 10.17, '', @xml['enderExped/xLgr'] + ', ' + @xml['enderExped/nro'] + (@xml['enderExped/xCpl'] != '' ? ' - ' + @xml['enderExped/xCpl'] : ''), { :size => 7, :border => 0, :style => :bold } if @xml['enderExped/xLgr'] != ''
      @pdf.ibox 0.90, 5.00, 1.88, 10.44, '', @xml['enderExped/xBairro'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 10.00, 0.28, 10.78, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 1.88, 10.78, '', @xml['enderExped/xMun'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 3.00, 6.50, 10.78, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 3.00, 7.20, 10.78, '', @xml['enderExped/CEP'][0,2] + '.' + @xml['enderExped/CEP'][3,3] + '-' + @xml['enderExped/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if @xml['enderExped/CEP'] != ''
      @pdf.ibox 0.90, 10.00, 0.28, 11.17, '', 'CNPJ/CPF: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 1.88, 11.17, '', @xml['exped/CNPJ'][0,2] + '.' + @xml['exped/CNPJ'][2,3] + '.' + @xml['exped/CNPJ'][5,3] + '/' + @xml['exped/CNPJ'][8,4] + '-' + @xml['exped/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if @xml['exped/CNPJ'] != ''
      @pdf.ibox 0.90, 10.00, 1.88, 11.17, '', @xml['exped/CPF'][0,3] + '.' + @xml['exped/CPF'][3,3] + '.' + @xml['exped/CPF'][6,3] + '-' + @xml['exped/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if @xml['exped/CPF'] != ''
      @pdf.ibox 0.90, 3.50, 6.50, 11.17, '', 'Inscr. Est.:' , { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 3.50, 7.85, 11.17, '', @xml['exped/IE'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 6.00, 0.28, 11.58, '', 'UF: ' + '                                    ' + 'País: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 6.00, 1.88, 11.58, '', @xml['enderExped/UF'] + '                               ' + @xml['enderExped/xPais'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 3.00, 6.50, 11.58, '', 'Fone: ', { :size => 7, :border => 0, :style => :italic }
      fone = @xml['exped/fone']
      unless fone.eql?('')
        if @xml['exped/fone'] != '' and fone.size > 8
          @pdf.ibox 0.90, 3.00, 7.20, 11.58, '', '(' + @xml['exped/fone'][0,2] + ')' + @xml['exped/fone'][2,4] + '-' + @xml['exped/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          @pdf.ibox 0.90, 3.00, 7.20, 11.58, '', @xml['exped/fone'][0,4] + '-' + @xml['exped/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end
    end

    def render_recebedor
      # recebedor
      @pdf.ibox 2.76, 10.24, 10.50, 9.62
      @pdf.ibox 0.90, 10.00, 10.53, 9.81, '', 'Recebedor: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 12.10, 9.81, '', @xml['receb/xNome'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 10.00, 10.53, 10.17, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 12.10, 10.17, '', @xml['enderReceb/xLgr'] + ', ' + @xml['enderReceb/nro'] + (@xml['enderReceb/xCpl'] != '' ? ' - ' + @xml['enderReceb/xCpl'] : ''), { :size => 7, :border => 0, :style => :bold } if @xml['enderReceb/xLgr'] != ''
      @pdf.ibox 0.90, 5.00, 12.10, 10.44, '', @xml['enderReceb/xBairro'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 10.00, 10.53, 10.78, '', 'Município: ' , { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 12.10, 10.78, '', @xml['enderReceb/xMun'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 3.00, 16.75, 10.78, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 3.00, 17.40, 10.78, '', @xml['enderReceb/CEP'][0,2] + '.' + @xml['enderReceb/CEP'][3,3] + '-' + @xml['enderReceb/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if @xml['enderReceb/CEP'] != ''
      @pdf.ibox 0.90, 10.00, 10.53, 11.17, '', 'CNPJ/CPF: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 12.10, 11.17, '', @xml['receb/CNPJ'][0,2] + '.' + @xml['receb/CNPJ'][2,3] + '.' + @xml['receb/CNPJ'][5,3] + '/' + @xml['receb/CNPJ'][8,4] + '-' + @xml['receb/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if @xml['receb/CNPJ'] != ''
      @pdf.ibox 0.90, 10.00, 12.10, 11.17, '', @xml['receb/CPF'][0,3] + '.' + @xml['receb/CPF'][3,3] + '.' + @xml['receb/CPF'][6,3] + '-' + @xml['receb/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if @xml['receb/CPF'] != ''
      @pdf.ibox 0.90, 3.50, 16.75, 11.17, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 3.50, 18.05, 11.17, '', @xml['receb/IE'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 6.00, 10.53, 11.58, '', 'UF: ' + '                                    ' + 'País: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 6.00, 12.10, 11.58, '', @xml['enderReceb/UF'] + '                               ' + @xml['enderReceb/xPais'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 3.00, 16.75, 11.58, '', 'Fone: ', { :size => 7, :border => 0, :style => :italic }
      fone = @xml['receb/fone']
      unless fone.eql?('')
        if @xml['receb/fone'] != '' and fone.size > 8
          @pdf.ibox 0.90, 3.00, 17.40, 11.58, '', '(' + @xml['receb/fone'][0,2] + ')' + @xml['receb/fone'][2,4] + '-' + @xml['receb/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          @pdf.ibox 0.90, 3.00, 17.40, 11.58, '', @xml['receb/fone'][0,4] + '-' + @xml['receb/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end
    end

    def render_tomador_do_servico
      # tomador
      @pdf.ibox 1.45, 20.49, 0.25, 12.38
      if @xml['ide/toma3'] != '' || @xml['ide/toma03'] != '' then
        @xml['ide/toma3'] != '' ? tomador = 'toma3' : tomador = 'toma03'
      else if @xml['ide/toma4'] != '' || @xml['ide/toma04'] != '' then
             @xml['ide/toma4'] != '' ? tomador = 'toma4' : tomador = 'toma04'
           end
      end
      toma = case @xml[tomador + '/toma']
               when '0' then 'rem'
               when '1' then 'exped'
               when '2' then 'receb'
               when '3' then 'dest'
               when '4' then 'Outros'
               else ''
             end
      endereco = case @xml[tomador + '/toma']
                     when '0' then 'enderReme'
                     when '1' then 'enderExped'
                     when '2' then 'enderReceb'
                     when '3' then 'enderDest'
                     when '4' then 'Outros'
                     else ''
                   end
      if toma == 'Outros'
        @pdf.ibox 0.90, 10.00, 0.28, 12.45, '', 'Tomador do Serviço: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 10.00, 2.58, 12.45, '', @xml['toma4/xNome'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 10.00, 10.50, 12.45, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 10.00, 11.80, 12.45, '', @xml['enderToma/xMun'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 4.00, 18.00, 12.45, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 4.00, 18.70, 12.45, '', @xml['enderToma/CEP'][0,2] + '.' + @xml['enderToma/CEP'][3,3] + '-' + @xml['enderToma/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if @xml['enderToma/CEP'] != ''
        @pdf.ibox 0.90, 10.00, 0.28, 12.81, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 10.00, 1.88, 12.81, '', @xml['enderToma/xLgr'] + ', ' + @xml['enderToma/nro'] + (@xml['enderToma/xCpl'] != '' ? ' - ' + @xml['enderToma/xCpl'] : '') + ' - ' + @xml['enderToma/xBairro'], { :size => 7, :border => 0, :style => :bold } if @xml['enderToma/xLgr'] != ''
        @pdf.ibox 0.90, 2.00, 13.50, 12.81, '', 'UF: ' , { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 2.00, 14.50, 12.81, '', @xml['enderToma/UF'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 5.00, 16.50, 12.81, '', 'País: ' , { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 5.00, 17.50, 12.81, '', @xml['enderToma/xPais'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 5.00, 0.28, 13.17, '', 'CNPJ/CPF: ' , { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 5.00, 1.88, 13.17, '', @xml['toma4/CNPJ'][0,2] + '.' + @xml['toma4/CNPJ'][2,3] + '.' + @xml['toma4/CNPJ'][5,3] + '/' + @xml['toma4/CNPJ'][8,4] + '-' + @xml['toma4/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if @xml['toma4/CNPJ'] != ''
        @pdf.ibox 0.90, 5.00, 1.88, 13.17, '', @xml['toma4/CPF'][0,3] + '.' + @xml['toma4/CPF'][3,3] + '.' + @xml['toma4/CPF'][6,3] + '-' + @xml['toma4/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if @xml['toma4/CPF'] != ''
        @pdf.ibox 0.90, 5.00, 5.60, 13.17, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 5.00, 7.20, 13.17, '', @xml['toma4/IE'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 5.00, 10.50, 13.17, '', 'Fone: ' , { :size => 7, :border => 0, :style => :italic }
        fone = @xml['toma4/fone']
        unless fone.eql?('')
          if fone.size > 8
            @pdf.ibox 0.90, 5.00, 11.80, 13.17, '', '(' + @xml['toma4/fone'][0,2] + ')' + @xml['toma4/fone'][2,4] + '-' + @xml['toma4/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
          else
            @pdf.ibox 0.90, 5.00, 11.80, 13.17, '', @xml['toma4/fone'][0,4] + '-' + @xml['toma4/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
          end
        end
      else
        @pdf.ibox 0.90, 10.00, 0.28, 12.45, '', 'Tomador do Serviço: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 10.00, 2.58, 12.45, '', @xml[toma + '/xNome'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 10.00, 10.50, 12.45, '', 'Município: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 10.00, 11.80, 12.45, '', @xml[endereco + '/xMun'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 4.00, 18.00, 12.45, '', 'CEP: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 4.00, 18.70, 12.45, '', @xml[endereco + '/CEP'][0,2] + '.' + @xml[endereco + '/CEP'][3,3] + '-' + @xml[endereco + '/CEP'][5,3], { :size => 7, :border => 0, :style => :bold } if @xml[endereco + '/CEP'] != ''
        @pdf.ibox 0.90, 10.00, 0.28, 12.81, '', 'Endereço: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 10.00, 1.88, 12.81, '', @xml[endereco + '/xLgr'] + ', ' + @xml[endereco + '/nro'] + (@xml[endereco + '/xCpl'] != '' ? ' - ' + @xml[endereco + '/xCpl'] : '') + ' - ' + @xml[endereco + '/xBairro'], { :size => 7, :border => 0, :style => :bold } if @xml[endereco + '/xLgr'] != ''
        @pdf.ibox 0.90, 2.00, 13.50, 12.81, '', 'UF: ' , { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 2.00, 14.50, 12.81, '', @xml[endereco + '/UF'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 5.00, 16.50, 12.81, '', 'País: ' , { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 5.00, 17.50, 12.81, '', @xml[endereco + '/xPais'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 5.00, 0.28, 13.17, '', 'CNPJ/CPF: ' , { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 5.00, 1.88, 13.17, '', @xml[toma + '/CNPJ'][0,2] + '.' + @xml[toma + '/CNPJ'][2,3] + '.' + @xml[toma + '/CNPJ'][5,3] + '/' + @xml[toma + '/CNPJ'][8,4] + '-' + @xml[toma + '/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if @xml[toma + '/CNPJ'] != ''
        @pdf.ibox 0.90, 5.00, 1.88, 13.17, '', @xml[toma + '/CPF'][0,3] + '.' + @xml[toma + '/CPF'][3,3] + '.' + @xml[toma + '/CPF'][6,3] + '-' + @xml[toma + '/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if @xml[toma + '/CPF'] != ''
        @pdf.ibox 0.90, 5.00, 5.60, 13.17, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
        @pdf.ibox 0.90, 5.00, 7.20, 13.17, '', @xml[toma + '/IE'], { :size => 7, :border => 0, :style => :bold }
        @pdf.ibox 0.90, 5.00, 10.50, 13.17, '', 'Fone: ' , { :size => 7, :border => 0, :style => :italic }
        fone =  @xml[toma + '/fone']
        unless fone.eql?('')
          if fone.size > 8
            @pdf.ibox 0.90, 5.00, 11.80, 13.17, '', '(' + @xml[toma + '/fone'][0,2] + ')' + @xml[toma + '/fone'][2,4] + '-' + @xml[toma + '/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
          else
            @pdf.ibox 0.90, 5.00, 11.80, 13.17, '', @xml[toma + '/fone'][0,4] + '-' + @xml[toma + '/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
          end
        end
      end
    end

    def render_produto
      #produto predominante/outras caract, valor total
      #@pdf.ibox 0.92, 20.49, 0.25, 13.82
      @pdf.ibox 0.90, 6.83, 0.25, 13.82, 'PRODUTO PREDOMINANTE', @xml['infCarga/proPred'], {:size => 7, :style => :bold }
      @pdf.ibox 0.90, 6.83, 7.09, 13.82, 'OUTRAS CARACTERÍSTICAS DA CARGA', @xml['infCarga/xOutCat'], {:size => 7, :style => :bold }
      @pdf.ibox 0.90, 6.82, 13.92, 13.82, 'VALOR TOTAL DA MERCADORIA', @xml['infCarga/vCarga'].empty? ? '0,00' : @xml['infCarga/vCarga'], {:size => 7, :style => :bold }
    end

    def render_quantidade
      #quantidade carga
      @pdf.ibox 0.90, 1.07, 0.25, 14.72, '', 'QTD.', { :size => 7, :align => :center, :style => :italic}
      @pdf.ibox 0.90, 1.07, 0.25, 15.02, '', 'CARGA', { :size => 7, :align => :center, :style => :italic, :border => 0}
      @pdf.ibox 0.90, 3.50, 1.33, 14.72, 'QT./UN. MEDIDA', '', { :size => 7, :style => :italic }
      @pdf.ibox 0.90, 3.50, 4.83, 14.72, 'QT./UN. MEDIDA', '', { :size => 7, :style => :italic }
      @pdf.ibox 0.90, 3.50, 8.33, 14.72, 'QT./UN. MEDIDA', '', { :size => 7, :style => :italic }
      x = 1.33
      @xml.collect('xmlns', 'infQ') { |det|
        if !det.css('cUnid').text.eql?('00')
           @pdf.ibox 0.90, 3.50, x, 15.02, '', det.css('qCarga').text, { :size => 7, :style => :bold, :border => 0 }
           x = x + 3.50
        end
      }
    end

    def render_seguradora
      #seguradora
      respons = case @xml['seg/respSeg']
         when '0' then 'Remetente'
         when '1' then 'Expedidor'
         when '2' then 'Recebedor'
         when '3' then 'Destinatário'
         when '4' then 'Emitente do CT-e'
         when '5' then 'Tomador de Serviço'
        else ''
      end
      @pdf.ibox 0.30, 8.91, 11.83, 14.72, 'Nome da Seguradora: ' + @xml['seg/xSeg'], '', {:size => 7}
      @pdf.ibox 0.60, 3.70, 11.83, 15.02, '', 'Responsável: ' + respons, {:size => 6}
      @pdf.ibox 0.60, 2.50, 15.52, 15.02, '', 'Nº Apólice: ' + @xml['seg/nApol'], { :size => 6}
      @pdf.ibox 0.60, 2.73, 18.01, 15.02, '', 'Nº Averbação: ' + @xml['seg/nAver'], { :size => 6}
    end

    def render_valor_da_prestacao
      #componentes do valor da prestação de serviço
      @pdf.ibox 0.40, 20.49, 0.25, 15.63, '', 'COMPONENTES DO VALOR DA PRESTAÇÃO DE SERVIÇO', { :align => :left, :size => 7, :style => :bold, :border => 0}
      @pdf.ibox 1.40, 4.00, 0.25, 16.03
      @pdf.ibox 1.40, 2.12, 0.25, 16.02, 'NOME', '', { :size => 7, :border => 0 }
      @pdf.ibox 1.40, 1.88, 3.05, 16.02, 'VALOR', '', { :size => 7, :border => 0 }
      @pdf.ibox 1.40, 4.00, 4.26, 16.03
      @pdf.ibox 1.40, 2.12, 4.26, 16.02, 'NOME', '', { :size => 7, :border => 0 }
      @pdf.ibox 1.40, 1.88, 7.14, 16.02, 'VALOR', '', { :size => 7, :border => 0 }
      @pdf.ibox 1.40, 4.00, 8.25, 16.03
      @pdf.ibox 1.40, 2.12, 8.25, 16.02, 'NOME', '', { :size => 7, :border => 0 }
      @pdf.ibox 1.40, 1.88, 11.05, 16.02, 'VALOR', '', { :size => 7, :border => 0 }
      @pdf.ibox 1.40, 4.00, 12.26, 16.03
      @pdf.ibox 1.40, 2.12, 12.26, 16.02, 'NOME', '', { :size => 7, :border => 0 }
      @pdf.ibox 1.40, 1.88, 15.05, 16.02, 'VALOR', '',{ :size => 7, :border => 0 }
      x = 0.25
      y = 16.40
      @xml.collect('xmlns', 'Comp') { |det|
        @pdf.ibox 1.40, 2.12, x, y, '', det.css('xNome').text, { :size => 6, :border => 0, :style => :bold }
        @pdf.inumeric 1.40, 1.88, x + 1.80, y, '', det.css('vComp').text, { :size => 7, :border => 0, :align => :right, :style => :bold }
        y = y + 0.40
        if y > 16.80
           x = x + 4.00
           y = 16.40
        end
      }
      @pdf.ibox 0.70, 4.48, 16.26, 16.03
      @pdf.inumeric 0.70, 4.48, 16.26, 16.03, 'VALOR TOTAL DO SERVIÇO', @xml['vPrest/vTPrest'], { :align => :center, :size => 6, :style => :bold}
      @pdf.inumeric 0.70, 4.48, 16.26, 16.73, 'VALOR A RECEBER', @xml['vPrest/vRec'],{ :align => :center, :size => 6, :style => :bold }
    end

    def render_impostos
      #informações relativas ao Imposto
      @pdf.ibox 0.40, 20.49, 0.25, 17.42, '', 'INFORMAÇÕES RELATIVAS AO IMPOSTO', { :align => :left, :size => 7, :border => 0, :style => :bold }
      if !@xml['imp/ICMS/ICMS00'].eql?("")
         cst = '00 - Tributação Normal ICMS'
         tipoIcms = 'ICMS00'
      elsif !@xml['imp/ICMS/ICMS20'].eql?("")
         cst = '20 - Tributação com BC reduzida do ICMS'
         tipoIcms = 'ICMS20'
      elsif !@xml['imp/ICMS/ICMS45'].eql?("")
         cst = '40 - ICMS Isenção;  41 - ICMS não tributada;  51 - ICMS diferido'
         tipoIcms = 'ICMS45'
      elsif !@xml['imp/ICMS/ICMS60'].eql?("")
         cst = '60 - ICMS cobrado anteriormente por Substituição Tributária'
         tipoIcms = 'ICMS60'
      elsif !@xml['imp/ICMS/ICMS90'].eql?("")
         cst = '90 - ICMS outros'
         tipoIcms = 'ICMS90'
      elsif !@xml['imp/ICMS/ICMSSN'].eql?("")
         cst = 'Simples Nacional'
         tipoIcms = 'ICMSSN'
      else
        cst = '90 - ICMS outros'
        tipoIcms = 'ICMSOutraUF'
      end
      @pdf.ibox 0.90, 10.00, 0.25, 17.83, 'SITUAÇÃO TRIBUTÁRIA', cst, { :size => 7, :style => :bold }
      @pdf.inumeric 0.90, 3.00, 10.25, 17.83, 'BASE DE CÁLCULO', @xml['imp/ICMS/'+ tipoIcms + '/vBC'], { :size => 7, :style => :bold }
      @pdf.inumeric 0.90, 1.00, 13.25, 17.83, 'AL. ICMS', @xml[('imp/ICMS/' + tipoIcms + '/pICMS')], { :size => 7, :style => :bold }
      @pdf.inumeric 0.90, 3.00, 14.25, 17.83, 'VALOR ICMS', @xml['imp/ICMS/' +  tipoIcms + '/vICMS'],{ :size => 7, :style => :bold }
      @pdf.inumeric 0.90, 2.00, 17.25, 17.83, '% RED.BC.CALC.', @xml['imp/ICMS/' + tipoIcms + '/pRedBC'], { :size => 7, :style => :bold }
      @pdf.inumeric 0.90, 1.49, 19.25, 17.83, 'ICMS ST.', @xml['imp/ICMS/' + tipoIcms + '/pRedBC'], { :size => 7, :style => :bold }
    end

    def render_documentos_originarios
      #documentos originários
      @pdf.ibox 0.40, 20.49, 0.25, 18.73, '', 'DOCUMENTOS ORIGINÁRIOS', { :align => :left, :size => 7, :style => :bold, :border => 0 }
      @pdf.ibox 5.52, 1.75, 0.25, 19.13, 'TP DOC.', '', { :size => 7}
      @pdf.ibox 5.52, 5.50, 2.00, 19.13, 'CNPJ/CPF EMITENTE/CHAVE', '', { :size => 7}
      @pdf.ibox 5.52, 1.00, 7.50, 19.13, 'SÉRIE', '', { :size => 7}
      @pdf.ibox 5.52, 2.00, 8.50, 19.13, 'Nº DOCUMENTO', '', { :size => 7}
      @pdf.ibox 5.52, 1.75, 10.50, 19.13, 'TP DOC.', '', { :size => 7}
      @pdf.ibox 5.52, 5.50, 12.25, 19.13, 'CNPJ/CPF EMITENTE/CHAVE', '', { :size => 7}
      @pdf.ibox 5.52, 1.00, 17.75, 19.13, 'SÉRIE', '', { :size => 7}
      @pdf.ibox 5.52, 2.00, 18.74, 19.13, 'Nº DOCUMENTO', '', { :size => 7}
      x = 0.25
      @xml.collect('xmlns', 'infNF') { |det|
        @pdf.ibox 5.52, 1.50, x, 19.43, '', det.css('mod').text, { :size => 7, :border => 0, :style => :bold }
        x = x + 1.75
        @pdf.ibox 5.52, 2.25, x, 19.43, '', @xml['rem/CNPJ'][0,2] + '.' + @xml['rem/CNPJ'][2,3] + '.' +@xml['rem/CNPJ'][5,3] + '/' + @xml['rem/CNPJ'][8,4] + '-' + @xml['rem/CNPJ'][12,2], { :size => 7, :border => 0, :style => :bold } if @xml['rem/CNPJ'] != ''
        @pdf.ibox 5.52, 5.25, x, 19.43, '', @xml['rem/CPF'][0,3] + '.' + @xml['rem/CPF'][3,3] + '.' +@xml['rem/CPF'][6,3] + '-' + @xml['rem/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if @xml['rem/CPF'] != ''
        x = x + 5.50
        @pdf.ibox 5.52, 0.75, x, 19.43, '', det.css('serie').text, { :size => 7, :border => 0, :style => :bold }
        x = x + 1.00
        @pdf.ibox 5.52, 1.75, x, 19.43, '', det.css('nDoc').text, { :size => 7, :border => 0, :style => :bold }
        x = x + 2.00
      }
      # NFe
      @xml.collect('xmlns', 'infNFe') { |det|
        chave = det.css('chave').text
        unless chave.empty?
          @pdf.ibox 5.52, 1.50, x, 19.43, '', 'NFe', { :size => 7, :border => 0, :style => :bold }
          x = x + 1.75
          @pdf.ibox 5.52, 5.25, x, 19.43, '', chave, { :size => 6, :border => 0, :style => :bold }
          x = x + 5.50
          @pdf.ibox 5.52, 0.75, x, 19.43, '', chave[22, 3], { :size => 7, :border => 0, :style => :bold }
          x = x + 1.00
          @pdf.ibox 5.52, 1.75, x, 19.43, '', chave[25, 9].gsub(/^[0]+/, ''), { :size => 7, :border => 0, :style => :bold }
          x = x + 2.00
        end
      }
    end

    def render_observacoes
      #OBSERVAÇÕES
      @pdf.ibox 0.40, 20.49, 0.25, 24.65, '', 'OBSERVAÇÕES', { :align => :left, :size => 7, :style => :bold, :border => 0 }
      @pdf.ibox 1.40, 20.49, 0.25, 25.05, '', (@xml['compl/xObs'] + "\n CTe COMPLEMENTADO " + "Chave: " + @xml['infCteComp/chave'] + " Valor de serviço: " +
      Helper.numerify(@xml['vPresComp/vTPrest']).to_s ), { :align => :left, :size => 7 }
    end

    def render_modal
      #informações do modal
      @pdf.ibox 0.40, 20.49, 0.25, 26.45, '', 'INFORMAÇÕES ESPECÍFICAS DO MODAL RODOVIÁRIO - CARGA FRACIONADA', { :align => :left, :size => 7, :style => :bold, :border => 0}
      @pdf.ibox 0.90, 3.00, 0.25, 26.85, 'RNTRC DA EMPRESA', @xml['rodo/RNTRC'], { :size => 7, :style => :bold }
      @pdf.ibox 0.90, 3.00, 3.25, 26.85, 'CIOT', @xml['rodo/CIOT'], { :size => 7, :style => :bold }

      dtentrega = @xml['rodo/dPrev'][8, 2].to_s + '/' + @xml['rodo/dPrev'][5, 2].to_s + '/' + @xml['rodo/dPrev'][0, 4].to_s

      @pdf.ibox 0.90, 4.00, 6.25, 26.85, 'DATA PREVISTA DE ENTREGA', dtentrega, { :size => 7, :style => :bold }
      @pdf.ibox 0.90, 10.49, 10.25, 26.85, '', 'ESTE CONHECIMENTO DE TRANSPORTE ATENDE A LEGISLAÇÃO DE TRANSPORTE RODOVIÁRIO EM VIGOR', { :size => 5, :align => :center }

      #informações do modal
      @pdf.ibox 0.40, 15.49, 0.25, 27.75, '', 'USO EXCLUSIVO DO EMISSOR DO CT-e', { :align => :center, :size => 7 }
      @pdf.ibox 1.20, 15.49, 0.25, 28.15, '', '', { :align => :center, :size => 6 }
      @pdf.ibox 0.40, 5.00, 15.74, 27.75, '', 'RESERVADO AO FISCO', { :align => :center, :size => 7 }
      @pdf.ibox 1.20, 5.00, 15.74, 28.15, '', '', { :align => :center, :size => 6 }
    end
  end
end
