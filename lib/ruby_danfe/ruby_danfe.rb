module RubyDanfe
  def self.generate(pdf_filename, xml_filename, type = :danfe)
    xml_string = File.new(xml_filename)
    render_file(pdf_filename, xml_string, type)
  end

  def self.render(xml_string, type = :danfe)
    pdf = generatePDF(xml_string, type)
    pdf.render
  end

  def self.render_file(pdf_filename, xml_string, type = :danfe)
    pdf = generatePDF(xml_string, type)
    pdf.render_file pdf_filename
  end

  private
  def self.generatePDF(xml_string, type = :danfe)
    xml = XML.new(xml_string)

    if type == :danfe
      generator = DanfeGenerator.new
    else
      generator = DacteGenerator.new
    end

    pdf = generator.generatePDF(xml)
    pdf
  end
end
