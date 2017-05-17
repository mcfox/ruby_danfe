# encoding:utf-8
require 'digest/sha1'

module RubyDanfe
  class DanfeNfceGenerator
    def initialize(xml)
      @xml = xml
      @pdf = Document.new(page_size: [390, 845])
    end

    def generatePDF
      @pdf.repeat :all do
        render_cabecalho
        render_info_fixas
        render_detalhes_venda
        render_totais
        render_tributos
        render_mensagem_fiscal
        render_consumidor
        render_qrcode
      end

      render_produtos

      @pdf
    end

    private
    def render_cabecalho

      # ibox(h, w, x, y, title = '', info = '', options = {})

      @pdf.ibox 3, 12, 0.9, 1

      @pdf.ibox 2.85, 3, 1.5, 2, "", "NFC-e", {:size => 12, :align => :center, :border => 0, :style => :bold}

      @pdf.ibox 4.92, 7, 4, 0, '',
        @xml['emit/xNome'] + "\n" +
        "CNPJ: " + @xml['emit/CNPJ'] + "\n" +
        @xml['enderEmit/xLgr'] + ", " + @xml['enderEmit/nro'] + "\n" +
        @xml['enderEmit/xBairro']+ " " + "-" + " " + @xml['enderEmit/xMun'] + "/" + @xml['enderEmit/UF'] + "\n" +
        "Fone: " + @xml['enderEmit/fone'] + "\n" +
        "CEP: " + @xml['enderEmit/CEP'] + " - " + "IE: " + @xml['emit/IE'], {:align => :center, :valign => :center, size: 8, border: 0}
    end

    def render_info_fixas
      @pdf.ibox 2, 12, 0.9, 4, '',
        "DANFE NFC-e - Documento Auxiliar da Nota Fiscal Eletrônica" + "\n" + "para Consumidor Final" + "\n \n" +
        "Não permite aproveitamento de crédito de ICMS", {align: :center, :valign => :center, size: 8}
    end

    def render_detalhes_venda
      render_cabecalho_dos_produtos

      totais =  @xml.css('total')

      @pdf.inumeric 0.70, 4, 0.9, 15.8, "Subtotal", totais.css('vProd').text, {:size => 6}
      @pdf.inumeric 0.70, 4, 4.9, 15.8, "Desconto", totais.css('vDesc').text, {:size => 6}
      @pdf.inumeric 0.70, 4, 8.9, 15.8, "Troco", totais.css('vTroco').text, {:size => 6}
    end

    def render_cabecalho_dos_produtos
      @pdf.ibox 9.55, 1.3, 0.9, 6.1, "CÓDIGO", "",{:size => 8, :align => :center, :style => :bold}
      @pdf.ibox 9.55, 1.3, 2.2, 6.1, "UNIDADE"
      @pdf.ibox 9.55, 5.1, 3.5, 6.1, "DESCRIÇÃO"
      @pdf.ibox 9.55, 1.3, 8.6, 6.1, "QUANT"
      @pdf.ibox 9.55, 1.5, 9.9, 6.1, "VALOR UNIT"
      @pdf.ibox 9.55, 1.5, 11.4, 6.1, "VALOR TOTAL"

      @pdf.horizontal_line 26, 365, at: 630
    end

    def render_produtos
      @pdf.font_size(6) do
        @pdf.itable 9.37, 21.50, 0.9, 6.6,
          @xml.collect('xmlns', 'det')  { |det|
             [
              det.css('prod/cProd').text, # CÓDIGO
              det.css('prod/uCom').text, # UNIDADE
              det.css('prod/xProd').text, # DESCRICAO
              Helper.numerify(det.css('prod/qCom').text), # QUANTIDADE
              Helper.numerify(det.css('prod/vUnCom').text), # VALOR UNIT
              Helper.numerify(det.css('prod/vProd').text), # VALOR TOTAL
            ]
          },
          :column_widths => {
            0 => 1.30.cm,
            1 => 1.30.cm,
            2 => 5.10.cm,
            3 => 1.30.cm,
            4 => 1.50.cm,
            5 => 1.50.cm
          },
          :cell_style => {:padding => 2, :border_width => 0} do |table|
            table.column(6..13).style(:align => :right)
            table.column(0..13).border_width = 1
            table.column(0..13).borders = [:bottom]
          end
      end
    end

    def get_produtos(produto, row = [])
      row << produto.css('cProd').text
      row << produto.css('uCom').text
      row << produto.css('xProd').text
      row << produto.css('qCom').text
      row << produto.css('vUnCom').text
      row << produto.css('vProd').text
      return row
    end

    def render_totais
      qtde_produtos =   @xml.css('det').count
      forma_pgto    =   get_forma_pgto
      valor_total   =   Helper.numerify(@xml.css('total').css('vProd').text)
      vlr_pago      =   Helper.numerify(@xml.css('vPag').text)

      @pdf.ibox 2, 12, 0.9, 16.7, '',
        "QTD. TOTAL DE ITENS: #{qtde_produtos}" + "\n" + "FORMA DE PAGAMENTO: #{forma_pgto}" + "\n" + "VALOR TOTAL (R$): #{valor_total}" + "\n" + "VALOR PAGO (R$): #{vlr_pago}", {align: :right, valign: :right, size: 6, border: 0, style: :bold}
    end

    def get_forma_pgto
      cod_forma_pgto = @xml.css('tPag').text
      case cod_forma_pgto
      when "01" then "Dinheiro"
        when "02" then "Cheque"
        when "03" then "Cartão de Crédito"
        when "04" then "Cartão de Débito"
        when "05" then "Crédito Loja"
        when "10" then "Vale Alimentação"
        when "11" then "Vale Refeição"
        when "12" then "Vale Presente"
        when "13" then "Vale Combustível"
        when "99" then "Outros"
      end
    end

    def render_tributos
      totais =  @xml.css('total')
      soma_tributos = totais.css('vII').text.to_f + totais.css('vIPI').text.to_f + totais.css('vIPI').text.to_f + totais.css('vPIS').text.to_f
        + totais.css('vCOFINS').text.to_f + totais.css('vOutro').text.to_f

      @pdf.ibox 0.9, 12, 0.9, 18, 'Tributos',
        "Informação dos Tributos Totais Incidentes (Lei Federal 12.741 /2012):   #{soma_tributos}", {align: :center, :valign => :center, size: 7}
    end

    def render_mensagem_fiscal
      numero_nota = @xml.css('nNF').text
      serie = @xml.css('serie').text
      data = @xml.css('dhEmi').text
      data_emissao = Date.parse(data).strftime('%d/%m/%Y %I:%M:%S')

      chave_acesso = get_chave
      cabecalho = ""

      tipo_emissao = @xml.css('tpEmis')
      if tipo_emissao != nil && tipo_emissao.text != "1"
        cabecalho = "EMITIDA EM CONTINGENCIA" + "\n \n"
      end

      @pdf.ibox 3, 12, 0.9, 18.9, 'Mensagem Fiscal',
        "#{cabecalho}" +
        "Número #{numero_nota} | Série #{serie} | Emissão #{data_emissao} - Via Consumidor" +
        "\n \n" + "Consulte pela Chave de Acesso em #{get_url_consulta}" +
        "\n \n" + "CHAVE DE ACESSO:" +
        "\n \n" + chave_acesso + "\n", {align: :center, :valign => :center, size: 7}
    end

    def get_chave
      chave = @xml.css('infNFe').attr("Id").value.gsub(/^(NFe|CTe)/, "")
      return "%s %s %s %s %s %s %s %s %s %s %s" %[chave[0..3], chave[4..7], chave[8..11], chave[12..15], chave[16..19], chave[20..23], chave[24..27], chave[28..31], chave[32..35], chave[36..39], chave[40..43]]
    end

    def render_consumidor
      consumidor = @xml.xpath("//dest")
      nome = @xml.regex_string(consumidor.to_s.downcase, "//xnome").text.split.map(&:capitalize).join(' ')

      endereco = @xml.regex_string(consumidor.to_s.downcase, "//xlgr").text + " - " + @xml.regex_string(consumidor.to_s.downcase, "//xbairro").text
      endereco += " - " + @xml.regex_string(consumidor.to_s.downcase, "//xmun").text + " - " + @xml.regex_string(consumidor.to_s.downcase, "//uf").text.downcase
      endereco = endereco.split.map(&:capitalize).join(' ')
      endereco = endereco.upcase

      if consumidor.any?
        documento = @xml.css('dest idEstrangeiro, dest CPF, dest CNPJ').text
        tipo_documento, documento =
          case documento.length
            when 11 then ["CPF", "%s.%s.%s-%s" % documento.match(/(...)(...)(...)(..)/).captures]
            when 14 then ["CNPJ", "%s.%s.%s/%s-%s" % documento.match(/(..)(...)(...)(....)(..)/).captures]
            else ["ID Estrangeiro", documento]
          end

        consumidor_msg = nome
        consumidor_msg += " - #{tipo_documento}: #{documento}"
        consumidor_msg += "\n" + endereco
      else
        consumidor_msg = "CONSUMIDOR NÃO IDENTIFICADO"
      end

      @pdf.ibox 1.3, 12, 0.9, 21.9, 'Consumidor',
        consumidor_msg, {align: :center, :valign => :top, size: 7}
    end

    def render_qrcode
      @pdf.iqrcode 5.18, 28, get_qrcode_url, 20

      data = @xml.css('dhRecbto').text
      data_receb = Date.parse(data).strftime('%d/%m/%Y %I:%M:%S')

      protocolo = @xml.css('nProt').text
      msg_protocolo = "Protocolo de Autorização: #{protocolo} - Data: #{data_receb}"

      @pdf.ibox 0.7, 12, 0.9, 23.3, '', msg_protocolo, size: 6, align: :center, valign: :center
    end

    def get_qrcode_url
      ender_consulta = get_ender_consulta
    end

    def get_ender_consulta
      url = get_url_qr_code

      params = {
        "chNFe" => get_chave.gsub(/ /, ""),
        "nVersao" => @xml.css('nfeProc').attr("versao"),
        "tpAmb" => @xml['ide/tpAmb'],
        "dhEmi" => str_to_hex(@xml['ide/dhEmi']),
        "vNF" => @xml['ICMSTot/vNF'],
        "vICMS" => @xml['ICMSTot/vICMS'],
        "digVal" => str_to_hex(@xml['nfe/DigestValue']),
        "cIdToken" => '000001',
      }

      unless @xml.css('dest').empty?
        params["cDest"] = @xml.css('dest idEstrangeiro, dest CPF, dest CNPJ').text
      end

      params_string = params.to_a.map{|p| p.join("=")}.join("&")

      hash_token = Digest::SHA1.base64digest params_string

      url + params_string + "&cHashQRCode=" + hash_token
    end

    def get_url_qr_code
      case @xml.css('emit').css('UF').text.upcase
        when "AC" then "http://www.sefaznet.ac.gov.br/nfe/NFe.jsp?opc=3"
        when "AM" then "http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?"
        when "MA" then "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?"
        when "MT" then "http://www.sefaz.mt.gov.br/nfe/portal/consultanfce?"
        when "RN" then "http://www.nfe.rn.gov.br/portal/consultarNFCe.jsp?"
        when "RO" then "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp?"
        when "RS" then "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?"
        when "SE" then "http://www.nfe.se.gov.br/portal/consultarNFCe.jsp?"
      end
    end

    def get_url_consulta
      case @xml.css('emit').css('UF').text.upcase
        when "AC" then "http://www.sefaznet.ac.gov.br/nfe/NFe.jsp?opc=3"
        when "AM" then "http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp"
        when "MA" then "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp"
        when "MT" then "http://www.sefaz.mt.gov.br/nfe/portal/consultanfce"
        when "RN" then "http://www.nfe.rn.gov.br/portal/consultarNFCe.jsp"
        when "RO" then "http://www.nfce.sefin.ro.gov.br"
        when "RS" then "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx"
        when "SE" then "http://www.nfe.se.gov.br/portal/consultarNFCe.jsp"
      end
    end

    def str_to_hex str
      str.split("").reduce("") do |str, char|
        str + char.ord.to_s(16)
      end
    end
  end
end
