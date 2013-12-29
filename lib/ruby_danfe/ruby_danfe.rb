module RubyDanfe
  def self.render(xml_string, type = :danfe)
    xml = XML.new(xml_string)
    pdf = if type == :danfe
            DanfeGenerator.generatePDF(xml)
          elsif type == :dacte
            DacteGenerator.generatePDFDacte(xml)
          end
    return pdf.render
  end

  def self.generate(pdf_filename, xml_filename, type = :danfe)
    xml = XML.new(File.new(xml_filename))
    pdf = if type == :danfe
            DanfeGenerator.generatePDF(xml)
          elsif type == :dacte
            DacteGenerator.generatePDFDacte(xml)
          end
    pdf.render_file pdf_filename
  end

  def self.render_file(pdf_filename, xml_string, type = :danfe)
    xml = XML.new(xml_string)
    pdf = if type == :danfe
            DanfeGenerator.generatePDF(xml)
          elsif type == :dacte
            DacteGenerator.generatePDFDacte(xml)
          end
    pdf.render_file pdf_filename
  end
end
