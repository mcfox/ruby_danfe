# encoding:utf-8
module RubyDanfe
  def self.generate(pdf_filename, xml_filename, type = :danfe, new_options = {})
    self.options = new_options if !new_options.empty?

    xml_string = File.new(xml_filename)
    render_file(pdf_filename, xml_string, type)
  end

  def self.render(xml_string, type = :danfe, new_options = {})
    self.options = new_options if !new_options.empty?

    pdf = generatePDF(xml_string, type)
    pdf.render
  end

  def self.render_file(pdf_filename, xml_string, type = :danfe, new_options = {})
    self.options = new_options if !new_options.empty?

    pdf = generatePDF(xml_string, type)
    pdf.render_file pdf_filename
  end

  def self.options
    @options ||= RubyDanfe::Options.new
  end

  def self.options=(new_options = {})
    @options = RubyDanfe::Options.new(new_options)
  end

  private
    def self.generatePDF(xml_string, type = :danfe, new_options = {})
      self.options = new_options if !new_options.empty?

      xml = XML.new(xml_string)

      generator =
        case type
          when :danfe then DanfeGenerator.new(xml)
          when :danfe_nfce then DanfeNfceGenerator.new(xml)
          when :dacte then DacteGenerator.new(xml)
          when :danfse then DanfseGenerator.new(xml)
          when :dacteos then DacteosGenerator.new(xml)
          when :damdfe then DamdfeGenerator.new(xml)
          else raise "unknown type #{type}"
        end
      generator.generatePDF
    end
end
