# coding: utf-8
module RubyDanfe
  class DanfeGenerator
    def initialize(xml)
      @xml = xml
      @pdf = Document.new
      @vol = 0
    end

    def generatePDF
      @pdf.repeat :all do
        render_canhoto
        render_emitente
        render_dados_adicionais_box
      end

      @pdf.repeat :all, dynamic: true do
        render_cabecalho_dos_produtos(@pdf.page_number)
      end

      render_titulo
      render_faturas
      render_calculo_do_imposto
      render_transportadora_e_volumes
      render_calculo_do_issqn

      render_dados_adicionais

      @pdf.go_to_page(1)
      render_produtos

      @pdf.page_count.times do |i|
        @pdf.go_to_page(i + 1)
        @pdf.ibox 1.00, 3.08, 6.71, 5.54, '',
        "FOLHA #{i + 1} de #{@pdf.page_count}", {:size => 8, :align => :center, :valign => :center, :border => 0, :style => :bold}
      end

      @pdf
    end

    private
    def render_canhoto
      @pdf.ibox 0.85, 16.10, 0.25, 0.42, "RECEBEMOS DE " + @xml['emit/xNome'] + " OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA ABAIXO"
      @pdf.ibox 0.85, 4.10, 0.25, 1.27, "DATA DE RECEBIMENTO"
      @pdf.ibox 0.85, 12.00, 4.35, 1.27, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR"

      @pdf.ibox 1.70, 4.50, 16.35, 0.42, '',
        "NF-e\n" +
        "N°. " + @xml['ide/nNF'] + "\n" +
        "SÉRIE " + @xml['ide/serie'], {:align => :center, :valign => :center}
    end

    def render_emitente
      @pdf.ibox 3.92, 6.46, 0.25, 2.54, '',
        @xml['emit/xNome'] + "\n" +
        @xml['enderEmit/xLgr'] + ", " + @xml['enderEmit/nro'] + "\n" +
        @xml['enderEmit/xBairro'] + " - " + @xml['enderEmit/CEP'] + "\n" +
        @xml['enderEmit/xMun'] + "/" + @xml['enderEmit/UF'] + "\n" +
        @xml['enderEmit/fone'] + " " + @xml['enderEmit/email'], {:align => :center, :valign => :center}

      @pdf.ibox 3.92, 3.08, 6.71, 2.54

      @pdf.ibox 0.60, 3.08, 6.71, 2.54, '', "DANFE", {:size => 12, :align => :center, :border => 0, :style => :bold}
      @pdf.ibox 1.20, 3.08, 6.71, 3.14, '', "DOCUMENTO AUXILIAR DA NOTA FISCAL ELETRÔNICA", {:size => 8, :align => :center, :border => 0}
      @pdf.ibox 0.60, 3.08, 6.71, 4.34, '', "#{@xml['ide/tpNF']} - " + (@xml['ide/tpNF'] == '0' ? 'ENTRADA' : 'SAÍDA'), {:size => 8, :align => :center, :border => 0}

      @pdf.ibox 1.00, 3.08, 6.71, 4.94, '',
        "N°. " + @xml['ide/nNF'] + "\n" +
        "SÉRIE " + @xml['ide/serie'], {:size => 8, :align => :center, :valign => :center, :border => 0, :style => :bold}

      @pdf.ibox 2.20, 11.02, 9.79, 2.54
      @pdf.ibarcode 1.50, 8.00, 10.4010, 4.44, @xml['chNFe']
      @pdf.ibox 0.85, 11.02, 9.79, 4.74, "CHAVE DE ACESSO", @xml['chNFe'].gsub(/\D/, '').gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "), {:style => :bold, :align => :center}
      @pdf.ibox 0.85, 11.02, 9.79, 5.60 , '', "Consulta de autenticidade no portal nacional da NF-e www.nfe.fazenda.gov.br/portal ou no site da Sefaz Autorizadora", {:align => :center, :size => 8}
      @pdf.ibox 0.85, 10.54, 0.25, 6.46, "NATUREZA DA OPERAÇÃO", @xml['ide/natOp']
      @pdf.ibox 0.85, 10.02, 10.79, 6.46, "PROTOCOLO DE AUTORIZAÇÃO DE USO", @xml['infProt/nProt'] + ' ' + Helper.format_datetime(@xml['infProt/dhRecbto']) , {:align => :center}
      @pdf.ibox 0.85, 6.86, 0.25, 7.31, "INSCRIÇÃO ESTADUAL", @xml['emit/IE']
      @pdf.ibox 0.85, 6.86, 7.11, 7.31, "INSC.ESTADUAL DO SUBST. TRIBUTÁRIO", @xml['emit/IEST']
      @pdf.ibox 0.85, 6.84, 13.97, 7.31, "CNPJ", @xml['emit/CNPJ']
    end

    def render_titulo
      @pdf.ititle 0.42, 10.00, 0.25, 8.16, "DESTINATÁRIO / REMETENTE"

      @pdf.ibox 0.85, 12.32, 0.25, 8.58, "NOME/RAZÃO SOCIAL", @xml['dest/xNome']
      @pdf.ibox 0.85, 5.33, 12.57, 8.58, "CNPJ/CPF", @xml['dest/CNPJ'] if @xml['dest/CNPJ'] != ''
      @pdf.ibox 0.85, 5.33, 12.57, 8.58, "CNPJ/CPF", @xml['dest/CPF'] if @xml['dest/CPF'] != ''
      @pdf.ibox 0.85, 2.92, 17.90, 8.58, "DATA DA EMISSÃO", (not @xml['ide/dEmi'].empty?) ? Helper.format_date(@xml['ide/dEmi']) : Helper.format_date(@xml['ide/dhEmi']) , {:align => :right}
      @pdf.ibox 0.85, 10.16, 0.25, 9.43, "ENDEREÇO", @xml['enderDest/xLgr'] + " " + @xml['enderDest/nro']
      @pdf.ibox 0.85, 4.83, 10.41, 9.43, "BAIRRO", @xml['enderDest/xBairro']
      @pdf.ibox 0.85, 2.67, 15.24, 9.43, "CEP", @xml['enderDest/CEP']
      @pdf.ibox 0.85, 2.92, 17.90, 9.43, "DATA DA SAÍDA/ENTRADA", (not @xml['ide/dSaiEnt'].empty?) ? Helper.format_date(@xml['ide/dSaiEnt']) : Helper.format_date(@xml['ide/dhSaiEnt']), {:align => :right}
      @pdf.ibox 0.85, 7.11, 0.25, 10.28, "MUNICÍPIO", @xml['enderDest/xMun']
      @pdf.ibox 0.85, 4.06, 7.36, 10.28, "FONE/FAX", @xml['enderDest/fone']
      @pdf.ibox 0.85, 1.14, 11.42, 10.28, "UF", @xml['enderDest/UF']
      @pdf.ibox 0.85, 5.33, 12.56, 10.28, "INSCRIÇÃO ESTADUAL", @xml['dest/IE']
      @pdf.ibox 0.85, 2.92, 17.90, 10.28, "HORA DE SAÍDA", Helper.format_time(@xml['ide/hSaiEnt']), {:align => :right}
      @pdf.ibox 0.85, 2.92, 17.90, 10.28, "HORA DE SAÍDA", (not @xml['ide/hSaiEnt'].empty?) ? Helper.format_time(@xml['ide/hSaiEnt']) : Helper.extract_time_from_date(@xml['ide/dhSaiEnt']) , {:align => :right}
    end

    def render_faturas
      @pdf.ititle 0.42, 10.00, 0.25, 11.12, "FATURA / DUPLICATAS"
      @pdf.ibox 0.85, 20.57, 0.25, 11.51

      x = 0.25
      y = 11.51
      @xml.collect('xmlns', 'dup') do |det|
        @pdf.ibox 0.85, 2.12, x, y, '', 'Núm.:', { :size => 6, :border => 0, :style => :italic }
        @pdf.ibox 0.85, 2.12, x + 0.70, y, '', det.css('nDup').text, { :size => 6, :border => 0 }
        @pdf.ibox 0.85, 2.12, x, y + 0.20, '', 'Venc.:', { :size => 6, :border => 0, :style => :italic }
        dtduplicata = det.css('dVenc').text
        dtduplicata = dtduplicata[8,2] + '/' + dtduplicata[5, 2] + '/' + dtduplicata[0, 4]
        @pdf.ibox 0.85, 2.12, x + 0.70, y + 0.20, '', dtduplicata, { :size => 6, :border => 0 }
        @pdf.ibox 0.85, 2.12, x, y + 0.40, '', 'Valor: R$', { :size => 6, :border => 0, :style => :italic }
        @pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.40, '', det.css('vDup').text, { :size => 6, :border => 0 }
        x = x + 2.30
      end

      @xml.collect('xmlns', 'fat') do |det|
        @pdf.ibox 0.85, 2.12, x, y, '', 'Núm.:', { :size => 4, :border => 0, :style => :italic }
        @pdf.ibox 0.85, 2.12, x + 0.70, y, '', det.css('nFat').text, { :size => 4, :border => 0 }

        @pdf.ibox 0.85, 2.12, x, y + 0.20, '', 'vOrig.: R$', { :size => 4, :border => 0, :style => :italic }
        @pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.18, '', det.css('vOrig').text, { :size => 4, :border => 0 }

        @pdf.ibox 0.85, 2.12, x, y + 0.40, '', 'vDesc: R$', { :size => 4, :border => 0, :style => :italic }
        @pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.36, '', det.css('vDesc').text, { :size => 4, :border => 0 }

        @pdf.ibox 0.85, 2.12, x, y + 0.55, '', 'vLiq: R$', { :size => 4, :border => 0, :style => :italic }
        @pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.54, '', det.css('vLiq').text, { :size => 4, :border => 0 }

        x = x + 2.30
      end
    end

    def render_calculo_do_imposto
      @pdf.ititle 0.42, 5.60, 0.25, 12.36, "CÁLCULO DO IMPOSTO"

      @pdf.inumeric 0.85, 4.06, 0.25, 12.78, "BASE DE CÁLCULO DO ICMS", @xml['ICMSTot/vBC']
      @pdf.inumeric 0.85, 4.06, 4.31, 12.78, "VALOR DO ICMS", @xml['ICMSTot/vICMS']
      @pdf.inumeric 0.85, 4.06, 8.37, 12.78, "BASE DE CÁLCULO DO ICMS ST", @xml['ICMSTot/vBCST']
      @pdf.inumeric 0.85, 4.06, 12.43, 12.78, "VALOR DO ICMS ST", @xml['ICMSTot/vST']
      @pdf.inumeric 0.85, 4.32, 16.49, 12.78, "VALOR TOTAL DOS PRODUTOS", @xml['ICMSTot/vProd']
      @pdf.inumeric 0.85, 3.46, 0.25, 13.63, "VALOR DO FRETE", @xml['ICMSTot/vFrete']
      @pdf.inumeric 0.85, 3.46, 3.71, 13.63, "VALOR DO SEGURO", @xml['ICMSTot/vSeg']
      @pdf.inumeric 0.85, 3.46, 7.17, 13.63, "DESCONTO", @xml['ICMSTot/vDesc']
      @pdf.inumeric 0.85, 3.46, 10.63, 13.63, "OUTRAS DESPESAS ACESSORIAS", @xml['ICMSTot/vOutro']
      @pdf.inumeric 0.85, 3.46, 14.09, 13.63, "VALOR DO IPI", @xml['ICMSTot/vIPI']
      @pdf.inumeric 0.85, 3.27, 17.55, 13.63, "VALOR TOTAL DA NOTA", @xml['ICMSTot/vNF'], :style => :bold
    end

    def render_transportadora_e_volumes
      @pdf.ititle 0.42, 10.00, 0.25, 14.48, "TRANSPORTADOR / VOLUMES TRANSPORTADOS"

      @pdf.ibox 0.85, 9.02, 0.25, 14.90, "RAZÃO SOCIAL", @xml['transporta/xNome']
      @pdf.ibox 0.85, 2.79, 9.27, 14.90, "FRETE POR CONTA", descricao_modalidade_frete(@xml['transp/modFrete'])
      @pdf.ibox 0.85, 1.78, 12.06, 14.90, "CODIGO ANTT", @xml['veicTransp/RNTC']
      @pdf.ibox 0.85, 2.29, 13.84, 14.90, "PLACA DO VEÍCULO", @xml['veicTransp/placa']
      @pdf.ibox 0.85, 0.76, 16.13, 14.90, "UF", @xml['veicTransp/UF']
      @pdf.ibox 0.85, 3.94, 16.89, 14.90, "CNPJ/CPF", @xml['transporta/CNPJ']
      @pdf.ibox 0.85, 9.02, 0.25, 15.75, "ENDEREÇO", @xml['transporta/xEnder']
      @pdf.ibox 0.85, 6.86, 9.27, 15.75, "MUNICÍPIO", @xml['transporta/xMun']
      @pdf.ibox 0.85, 0.76, 16.13, 15.75, "UF", @xml['transporta/UF']
      @pdf.ibox 0.85, 3.94, 16.89, 15.75, "INSCRIÇÂO ESTADUAL", @xml['transporta/IE']

      @vol = 0

      quantidade = 0
      peso_bruto = 0
      peso_liquido = 0

      especie = nil
      marca = nil

      @xml.collect('xmlns', 'vol') do |det|
        @vol += 1
        quantidade += det.css('qVol').text.to_f
        peso_bruto += det.css('pesoB').text.to_f
        peso_liquido += det.css('pesoL').text.to_f

        especie ||= det.css('esp').text
        marca ||= det.css('marca').text
      end

      if @vol == 0
        @pdf.ibox 0.85, 2.80, 0.25, 16.60, "QUANTIDADE"
        @pdf.ibox 0.85, 5.00, 3.05, 16.60, "ESPÉCIE"
        @pdf.ibox 0.85, 3.05, 8.05, 16.60, "MARCA"
        @pdf.ibox 0.85, 3.00, 11.10, 16.60, "NUMERAÇÃO"
        @pdf.ibox 0.85, 3.43, 14.10, 16.60, "PESO BRUTO"
        @pdf.ibox 0.85, 3.30, 17.53, 16.60, "PESO LÍQUIDO"
      else
        @pdf.ibox 0.85, 2.80, 0.25, 16.60, "QUANTIDADE", (quantidade.round == quantidade ? quantidade.to_i : quantidade).to_s
        @pdf.ibox 0.85, 5.00, 3.05, 16.60, "ESPÉCIE", especie
        @pdf.ibox 0.85, 3.05, 8.05, 16.60, "MARCA", marca
        @pdf.ibox 0.85, 3.00, 11.10, 16.60, "NUMERAÇÃO"
        @pdf.inumeric 0.85, 3.43, 14.10, 16.60, "PESO BRUTO", peso_bruto.to_s, {:decimals => 3}
        @pdf.inumeric 0.85, 3.30, 17.53, 16.60, "PESO LÍQUIDO", peso_liquido.to_s, {:decimals => 3}
      end
    end

    def render_cabecalho_dos_produtos(page_number)
      base_y = page_number == 1 ? 17.45 : 8.2
      height = page_number == 1 ? 6.70 : 17.2

      @pdf.ititle 0.42, 10.00, 0.25, base_y, "DADOS DO PRODUTO / SERVIÇO"

      @pdf.ibox height, 2.00, 0.25, base_y + 0.42, "CÓDIGO"
      @pdf.ibox height, 4.90, 2.25, base_y + 0.42, "DESCRIÇÃO"
      @pdf.ibox height, 1.30, 7.15, base_y + 0.42, "NCM"
      @pdf.ibox height, 0.80, 8.45, base_y + 0.42, "CST"
      @pdf.ibox height, 1.00, 9.25, base_y + 0.42, "CFOP"
      @pdf.ibox height, 1.00, 10.25, base_y + 0.42, "UNID"
      @pdf.ibox height, 1.30, 11.25, base_y + 0.42, "QUANT"
      @pdf.ibox height, 1.50, 12.55, base_y + 0.42, "VALOR UNIT"
      @pdf.ibox height, 1.50, 14.05, base_y + 0.42, "VALOR TOT"
      @pdf.ibox height, 1.50, 15.55, base_y + 0.42, "BASE CÁLC"
      @pdf.ibox height, 1.00, 17.05, base_y + 0.42, "VL ICMS"
      @pdf.ibox height, 1.00, 18.05, base_y + 0.42, "VL IPI"
      @pdf.ibox height, 0.90, 19.05, base_y + 0.42, "% ICMS"
      @pdf.ibox height, 0.86, 19.95, base_y + 0.42, "% IPI"
    end

    def render_calculo_do_issqn
      @pdf.ititle 0.42, 10.00, 0.25, 24.64, "CÁLCULO DO ISSQN"

      @pdf.ibox 0.85, 5.08, 0.25, 25.06, "INSCRIÇÃO MUNICIPAL", @xml['emit/IM']
      @pdf.ibox 0.85, 5.08, 5.33, 25.06, "VALOR TOTAL DOS SERVIÇOS", @xml['total/vServ'].empty? ? @xml['total/ISSQNtot/vServ'] : @xml['total/vServ']
      @pdf.ibox 0.85, 5.08, 10.41, 25.06, "BASE DE CÁLCULO DO ISSQN", @xml['total/vBCISS'].empty? ? @xml['total/ISSQNtot/vBC'] : @xml['total/vBCISS']
      @pdf.ibox 0.85, 5.28, 15.49, 25.06, "VALOR DO ISSQN", @xml['total/ISSTot'].empty? ? @xml['total/ISSQNtot/vISS'] : @xml['total/ISSTot']
    end

    def render_dados_adicionais_box
      @pdf.ititle 0.42, 10.00, 0.25, 25.91, "DADOS ADICIONAIS"
      @pdf.ibox 3.07, 12.93, 0.25, 26.33, "INFORMAÇÕES COMPLEMENTARES", '', {:size => 8, :valign => :top}

      @pdf.ibox 3.07, 7.62, 13.17, 26.33, "RESERVADO AO FISCO"
    end

    def render_dados_adicionais
      info_adicional = ""

      if @vol > 1
        info_adicional += "TRANSPORTADOR/VOLUMES TRANSPORTADOS\n"

        y = 26.67
        info_adicional += @xml.inject 'xmlns', 'vol', "" do |info, det|
          y = y + 0.15

          info +
            "QUANT.: #{det.css('qVol').text}   " +
            "ESPÉCIE: #{det.css('esp').text}   " +
            "MARCA: #{det.css('marca').text}   " +
            "PESO B.: #{det.css('pesoB').text}   " +
            "PESO LÍQ.: #{det.css('pesoL').text}\n"
        end

        info_adicional += "\nOUTRAS INFORMAÇÕES: "
      end

      info_adicional += @xml['infAdic/infCpl']

      if @xml.css('entrega')
        info_adicional += " LOCAL DA ENTREGA: " +
          @xml['entrega/xLgr'] + " " +
          @xml['entrega/nro'] + " " +
          "Bairro/Distrito: " + @xml['entrega/xBairro'] + " " +
          "Municipio: " + @xml['entrega/xMun'] + " " +
          "UF: " + @xml['entrega/UF'] + " " +
          "País: Brasil"
      end

      if @xml['infAdic/infAdFisco'] != ""
        info_adicional += "\n#{@xml['infAdic/infAdFisco']}"
      end

      @pdf.bounding_box [(0.33).cm, Helper.invert(26.78.cm)], height: 2.7.cm, width: 12.7.cm do
        @pdf.font_size 6
        @pdf.text info_adicional, align: :justify
      end
    end

    def render_produtos
      @pdf.font_size(6) do
        @produtos_box = @pdf.itable 6.37, 21.50, 0.25, 18.17,
          @xml.collect('xmlns', 'det')  { |det|
            [
              det.css('prod/cProd').text, #I02
              Descricao.generate(det), #I04
              #{}" ",
              det.css('prod/NCM').text, #I05
              Cst.to_danfe(det), #N11
              det.css('prod/CFOP').text, #I08
              det.css('prod/uCom').text, #I09
              Helper.format_quantity(det.css('prod/qCom').text),
              Helper.numerify(det.css('prod/vUnCom').text), #I10a
              Helper.numerify(det.css('prod/vProd').text), #I11
              Helper.numerify_default_zero(det.css('ICMS/*/vBC').text), #N15
              Helper.numerify_default_zero(det.css('ICMS/*/vICMS').text), #N17
              Helper.numerify_default_zero(det.css('IPI/*/vIPI').text), #O14
              Helper.numerify_default_zero(det.css('ICMS/*/pICMS').text), #N16
              Helper.numerify_default_zero(det.css('IPI/*/pIPI').text) #O13
            ]
          },
          :column_widths => {
            0 => 2.00.cm,
            1 => 4.90.cm,
            2 => 1.30.cm,
            3 => 0.80.cm,
            4 => 1.00.cm,
            5 => 1.00.cm,
            6 => 1.30.cm,
            7 => 1.50.cm,
            8 => 1.50.cm,
            9 => 1.50.cm,
            10 => 1.00.cm,
            11 => 1.00.cm,
            12 => 0.90.cm,
            13 => 0.86.cm
          },
          :cell_style => {:padding => 2, :border_width => 0} do |table|
            table.column(6..13).style(:align => :right)
            table.column(0..13).border_width = 1
            table.column(0..13).borders = [:top]
            table.before_rendering_page do |page|
              if @pdf.page_number == 1
                @pdf.bounds.instance_variable_set(:@y, (22.2).cm)
                @pdf.bounds.instance_variable_set(:@height, (16.8).cm)
              else
                @pdf.bounds.instance_variable_set(:@y, (21).cm)
              end
            end
          end
      end
    end

    def descricao_modalidade_frete(modalidade)
      case modalidade
      when '1'
        "1 - Destinatário (FOB)"
      when '2'
        "2 - Terceiros"
      when '3'
        "3 - Remetente (Transp. Próprio)"
      when '4'
        "4 - Remetente (Transp.Dest)"
      when '9'
        "9 - Sem frete"
      else
        "0 - Remetente(CIF)"
      end
    end
  end
end