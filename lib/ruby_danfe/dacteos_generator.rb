# coding: utf-8
module RubyDanfe
  class DacteosGenerator < RubyDanfe::DacteGenerator


    def render_infobox
      # infobox
      @pdf.ibox 0.90, 9.39, 7.92, 0.54, '', 'DACTEOS', { :align => :center, :style => :bold, :size => 12}
      @pdf.ibox 0.90, 9.39, 7.92, 0.94, '', 'Documento auxiliar do Conhecimento de Transporte Eletrônico para Outros Serviços', { :align => :center, :border => 0, :size => 7 }

      @pdf.ibox 0.90, 3.43, 17.31, 0.54, '', 'MODAL', { :align => :center, :size => 7 }
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

    def render_tomador
      # tomador
      toma_cnpj = @xml['toma/CNPJ']
      @pdf.ibox 0.90, 3.83, 0.25, 3.71, 'TOMADOR DO SERVIÇO', Helper.format_cnpj(toma_cnpj), { :align => :center, :size => 8, :style => :bold }
    end


    def render_tomador_do_servico
      # tomador
      @pdf.ibox 1.45, 20.49, 0.25, 12.38

      endereco = 'enderToma'
      @pdf.ibox 0.90, 10.00, 0.28, 12.45, '', 'Tomador do Serviço: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 10.00, 2.58, 12.45, '', @xml['toma/xNome'], { :size => 7, :border => 0, :style => :bold }
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
      @pdf.ibox 0.90, 5.00, 1.88, 13.17, '', Helper.format_cnpj(@xml['toma/CNPJ']), { :size => 7, :border => 0, :style => :bold } if @xml['toma/CNPJ'] != ''
      @pdf.ibox 0.90, 5.00, 1.88, 13.17, '', @xml['toma/CPF'][0,3] + '.' + @xml['toma/CPF'][3,3] + '.' + @xml['toma/CPF'][6,3] + '-' + @xml['toma/CPF'][9,2], { :size => 7, :border => 0, :style => :bold } if @xml['toma/CPF'] != ''
      @pdf.ibox 0.90, 5.00, 5.60, 13.17, '', 'Inscr. Est.: ', { :size => 7, :border => 0, :style => :italic }
      @pdf.ibox 0.90, 5.00, 7.20, 13.17, '', @xml['toma/IE'], { :size => 7, :border => 0, :style => :bold }
      @pdf.ibox 0.90, 5.00, 10.50, 13.17, '', 'Fone: ' , { :size => 7, :border => 0, :style => :italic }
      fone = @xml['toma/fone']
      unless fone.eql?('')
        if fone.size > 8
          @pdf.ibox 0.90, 5.00, 11.80, 13.17, '', '(' + @xml['toma/fone'][0,2] + ')' + @xml['toma/fone'][2,4] + '-' + @xml['toma/fone'][6,4], { :size => 7, :border => 0, :style => :bold }
        else
          @pdf.ibox 0.90, 5.00, 11.80, 13.17, '', @xml['toma/fone'][0,4] + '-' + @xml['toma/fone'][4,4], { :size => 7, :border => 0, :style => :bold }
        end
      end
    end

  end
end
