#encoding: utf-8

module RubyDanfe
  class Descricao
    LINEBREAK = "\n"

    def self.generate(det)
      descricao = "#{det.css('prod/xProd').text}"

      if need_infAdProd(det)
        descricao += det.css('infAdProd').text
      end

      if need_fci(det)
        descricao += LINEBREAK
        descricao += "FCI: #{det.css('prod/nFCI').text}"
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
  end
end
