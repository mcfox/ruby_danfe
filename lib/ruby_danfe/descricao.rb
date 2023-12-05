#encoding: utf-8

module RubyDanfe
  class Descricao
    LINEBREAK = "\n"

    def self.generate(det)
      descricao = "#{det.css('prod/xProd').text}"

      if need_infAdProd(det)
        descricao += LINEBREAK
        descricao += det.css('infAdProd').text
      end

      if need_fci(det)
        descricao += LINEBREAK
        descricao += "FCI: #{det.css('prod/nFCI').text}"
      end

      if need_veicProd(det)
        veicProd = det.css('veicProd')

        descricao += LINEBREAK
        descricao += "Chassi: #{veicProd.css('chassi').text} "
        descricao += "Motor: #{veicProd.css('nMotor').text} "
        descricao += "AnoFab: #{veicProd.css('anoFab').text} "
        descricao += "AnoMod: #{veicProd.css('anoMod').text} "
        descricao += "Cor: #{veicProd.css('xCor').text}"
      end

      if need_st(det)
        descricao += LINEBREAK
        descricao += "ST: MVA: #{det.css('ICMS/*/pMVAST').text}% "
        descricao += "* Alíq: #{det.css('ICMS/*/pICMSST').text}% "
        descricao += "* BC: #{det.css('ICMS/*/vBCST').text} "
        descricao += "* Vlr: #{det.css('ICMS/*/vICMSST').text}"
      end

      descricao
    end

    private
    def self.need_infAdProd(det)
      !det.css('infAdProd').text.empty?
    end

    def self.need_fci(det)
      !det.css('prod/nFCI').text.empty?
    end

    def self.need_veicProd(det)
      !det.css('prod/veicProd').text.empty?
    end

    def self.need_st(det)
      det.css('ICMS/*/vBCST').text.to_i > 0
    end

  end
end
