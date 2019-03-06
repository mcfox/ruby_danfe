# coding: utf-8
module RubyDanfe
  class DamdfeGenerator
    def initialize(xml)
      @xml = xml
      @pdf = Document.new
    end

    def generatePDF
      render_cabecalho
      render_titulo
      @pdf
    end

      # ibox(height, width, x, y, title = '', info = '', options = {})
    private
    def render_cabecalho
      @pdf.ibox 5, 20, 0.5, 1.25, ' ', 'REALFABANI TRANSPORTES EIRELI ME', { :align => :center, :style => :bold, :size => 14 }
      @pdf.ibox 0.90, 6, 7.5, 2.25, ' ', 'CNPJ: 21.715.390/0001-56          IE: 28.402.948-3', { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7.5, 2.75, ' ', 'ALEXANDRE FLEMING , Nro 1136', { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7.5, 3.25, ' ', 'NOVA BANDEIRANTES', { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7.5, 3.75, ' ', 'CAMPO GRANDE - MS', { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7.5, 4.25, ' ', '79006-570', { :align => :left, :border => 0, :size => 8 }
      @pdf.ibox 0.90, 6, 7.5, 4.75, ' ', '(67)99877-6797', { :align => :left, :border => 0, :size => 8 }
    end

    def render_titulo
      @pdf.ibox 1.5, 20, 0.5, 6.25, ' ', 'DAMDFE', { :align => :left, :style => :bold, :size => 16 }
      @pdf.ibox 0.90, 16, 6, 6.25, ' ', 'Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais', { :align => :center, :style => :bold, :border => 0, :size => 10 }
    end
  end
end