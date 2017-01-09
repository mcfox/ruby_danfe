module RubyDanfe
  class XML
    def css(xpath)
      @xml.css(xpath)
    end

    def xpath(regex)
      doc = Nokogiri::HTML(@xml.to_s)
      return doc.xpath(regex)
    end

    def regex_string(search_string, regex)
      doc = Nokogiri::HTML(search_string)
      return doc.xpath(regex)
    end

    def initialize(xml, logo = nil)
      @xml = Nokogiri::XML(xml)
      @logo = logo
    end

    def [](xpath)
      node = @xml.css(xpath)
      return node ? node.text : ""
    end

    def render
      if @xml.at_css('infNFe/ide')
        RubyDanfe.render @xml.to_s, :danfe, @logo
      else
        RubyDanfe.render @xml.to_s, :dacte, @logo
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
