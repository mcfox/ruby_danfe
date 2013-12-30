module RubyDanfe
  class XML
    def css(xpath)
      @xml.css(xpath)
    end

    def initialize(xml)
      @xml = Nokogiri::XML(xml)
    end

    def [](xpath)
      node = @xml.css(xpath)
      return node ? node.text : ""
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
        ""
      end
    end
  end
end
