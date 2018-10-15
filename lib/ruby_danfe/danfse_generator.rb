# coding: utf-8
module RubyDanfe
  class DanfseGenerator
    def initialize(xml)
      @xml = xml
      @pdf = Document.new
      @vol = 0
    end

    attr_reader :municipios

    def municipios
      lib_path = File.expand_path("../../", __FILE__)
      @municipios ||= JSON.parse(File.read(File.join(lib_path, 'municipios.json')))
    end

    def generatePDF
      render_titulo
      render_prestador
      render_tomador
      render_intermediario
      render_discriminacao
      render_valor_total
      render_outras
      @pdf
    end

    private
    def render_titulo
      @pdf.ibox 2.55, 16.10, 0.25, 0.42, '',
        "PREFEITURA DO MUNICÍPIO DE #{municipios[@xml['InfNfse/PrestadorServico/Endereco/CodigoMunicipio']].upcase} \n" +
        "Secretaria Municipal da Fazenda \n" +
        "NOTA FISCAL ELETRÔNICA DE SERVIÇOS - NFS-e \n" +
        "RPS n° #{@xml['IdentificacaoRps/Numero']}, emitido em #{@xml['DataEmissaoRps']}", {:align => :center, :valign => :center}

      @pdf.ibox 0.85, 4.47, 16.35, 0.42, "NÚMERO DA NOTA", "#{@xml['InfNfse/Numero'].rjust(8,'0')}"
      @pdf.ibox 0.85, 4.47, 16.35, 1.27, "DATA E HORA DE EMISSÃO", "#{@xml['InfNfse/DataEmissao'].gsub('T', ' ')}"
      @pdf.ibox 0.85, 4.47, 16.35, 2.12, "CÓDIGO DE VERIFICAÇÃO", "#{@xml['CodigoVerificacao']}"
    end

    def render_prestador
      @pdf.ibox 4.25, 20.57, 0.25, 2.97
      @pdf.ibox 0.85, 20.57, 0.25, 2.97, '', 'PRESTADOR DE SERVIÇOS', {border: 0, style: :bold,:align => :center, :valign => :center}
      @pdf.ibox 0.85, 20.57, 0.25, 3.82, "Nome/Razão Social", "#{@xml['PrestadorServico/RazaoSocial']}", {border: 0}
      @pdf.ibox 0.85, 12,    0.25, 4.67, "CPF/CNPJ", "#{@xml['PrestadorServico/IdentificacaoPrestador/Cnpj'] || @xml['PrestadorServico/IdentificacaoPrestador/Cpf']}", {border: 0}
      @pdf.ibox 0.85, 4.47,  12,   4.67, "Inscrição Municipal", "#{@xml['IdentificacaoPrestador/InscricaoMunicipal']}", {border: 0}
      @pdf.ibox 0.85, 20.57, 0.25, 5.52, "Endereço", "#{@xml['PrestadorServico/Endereco/Endereco']}", {border: 0}
      @pdf.ibox 0.85, 10,    0.25, 6.37, "Município", "#{municipios[@xml['PrestadorServico/Endereco/CodigoMunicipio']]}", {border: 0}
      @pdf.ibox 0.85, 4.47,  10,   6.37, "UF", "#{@xml['PrestadorServico/Endereco/Uf']}", {border: 0}
      @pdf.ibox 0.85, 4.47,  15,   6.37, "E-mail", "#{@xml['PrestadorServico/Contato/Email']}", {border: 0}
    end

    def render_tomador
      @pdf.ibox 4.25, 20.57, 0.25, 7.22
      @pdf.ibox 0.85, 20.57, 0.25, 7.22, '', 'TOMADOR DE SERVIÇOS', {border: 0, style: :bold,:align => :center, :valign => :center}
      @pdf.ibox 0.85, 20.57, 0.25, 8.07, "Nome/Razão Social", "#{@xml['TomadorServico/RazaoSocial']}", {border: 0}
      @pdf.ibox 0.85, 12,    0.25, 8.92, "CPF/CNPJ", "#{@xml['TomadorServico/IdentificacaoTomador/CpfCnpj/Cnpj'] || @xml['TomadorServico/IdentificacaoTomador/CpfCnpj/Cpf']}", {border: 0}
      @pdf.ibox 0.85, 4.47,  12,   8.92, "Inscrição Municipal", "#{@xml['IdentificacaoTomador/InscricaoMunicipal']}", {border: 0}
      @pdf.ibox 0.85, 20.57, 0.25, 9.77, "Endereço", "#{@xml['TomadorServico/Endereco/Endereco']}", {border: 0}
      @pdf.ibox 0.85, 10,    0.25, 10.62, "Município", "#{municipios[@xml['TomadorServico/Endereco/CodigoMunicipio']]}", {border: 0}
      @pdf.ibox 0.85, 4.47,  10,   10.62, "UF", "#{@xml['TomadorServico/Endereco/Uf']}", {border: 0}
      @pdf.ibox 0.85, 4.47,  15,   10.62, "E-mail", "#{@xml['TomadorServico/Contato/Email']}", {border: 0}
    end

    def render_intermediario
      @pdf.ibox 1.70, 20.57, 0.25,  11.47
      @pdf.ibox 0.85, 20.57, 0.25,  11.47, '', 'INTERMEDIÁRIO DE SERVIÇOS', {border: 0, style: :bold,:align => :center, :valign => :center}
      @pdf.ibox 0.85, 12,    0.25,  12.32, "Nome/Razão Social", "#{@xml['IdentificacaoIntermediarioServico/RazaoSocial']}", {border: 0}
      @pdf.ibox 0.85, 8,     12.25, 12.32, "CPF/CNPJ", "#{@xml['IdentificacaoIntermediarioServico/CpfCnpj/Cnpj'] || @xml['IdentificacaoIntermediarioServico/CpfCnpj/Cpf']}", {border: 0}
    end

    def render_discriminacao
      @pdf.ibox 9.35, 20.57, 0.25,  13.17
      @pdf.ibox 0.85, 20.57, 0.25,  13.17, '', 'DISCRIMINAÇÃO DOS SERVIÇOS', {border: 0, style: :bold,:align => :center, :valign => :center}
      @pdf.ibox 8, 19.57, 0.75,  14.02, "", "#{@xml['Servico/Discriminacao']}", {border: 0}
    end

    def render_valor_total
      @pdf.ibox 1.70, 20.57, 0.25,  22.52
      @pdf.ibox 0.85, 20.57, 0.25,  22.52, '', "VALOR TOTAL DO SERVIÇO = R$#{Helper.numerify(@xml['Servico/Valores/ValorServicos'])}", {border: 0, style: :bold,:align => :center, :valign => :center}
      @pdf.inumeric 0.85, 4.06,  0.25,  23.37, "INSS", @xml['Servico/Valores/ValorInss']
      @pdf.inumeric 0.85, 4.06,  4.31,  23.37, "IRRF", @xml['Servico/Valores/ValorIr']
      @pdf.inumeric 0.85, 4.06,  8.37,  23.37, "CSLL", @xml['Servico/Valores/ValorCsll']
      @pdf.inumeric 0.85, 4.06,  12.43, 23.37, "COFINS", @xml['Servico/Valores/ValorCofins']
      @pdf.inumeric 0.85, 4.32,  16.49, 23.37, "PIS/PASEP", @xml['Servico/Valores/ValorPis']
      @pdf.ibox 0.85, 20.57, 0.25,  24.22, "Código do Serviço", @xml['Servico/CodigoTributacaoMunicipio']
      @pdf.inumeric 0.85, 3.46,  0.25,  25.07, "Valor Total das Deduções", @xml['Servico/Valores/ValorDeducoes']
      @pdf.inumeric 0.85, 3.46,  3.71,  25.07 , "Base de Cálculo", @xml['Servico/Valores/BaseCalculo']
      @pdf.ibox 0.85, 3.46,  7.17,  25.07, "Alíquota", @xml['Servico/Valores/Aliquota']
      @pdf.inumeric 0.85, 3.46,  10.63, 25.07, "Valor do ISS", @xml['Servico/Valores/ValorIss']
      @pdf.inumeric 0.85, 6.73,  14.09, 25.07, "Crédito", @xml['InfNfse/ValorCredito']
      @pdf.ibox 0.85, 10.38, 0.25,  25.92, "Muncípio da Prestação do Serviço", municipios[@xml['Servico/CodigoMunicipio']], :style => :bold
      @pdf.ibox 0.85, 10.19, 10.63, 25.92, "Número Inscrição da Obra", @xml['DadosConstrucaoCivil/CodigoObra'], :style => :bold
    end

    def render_outras
      @pdf.ibox 2.55, 20.57, 0.25,  26.77
      @pdf.ibox 0.85, 20.57, 0.25,  26.77, '', 'OUTRAS INFORMAÇÕES', {border: 0, style: :bold,:align => :center, :valign => :center}
      @pdf.ibox 1.70, 19.57, 0.75,  27.62, "", "#{@xml['InfNfse/OutrasInformacoes']}", {border: 0}
    end
  end
end
