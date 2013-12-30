module RubyDanfe
  class Document
    def initialize
      @document = Prawn::Document.new(
        :page_size => 'A4',
        :page_layout => :portrait,
        :left_margin => 0,
        :right_margin => 0,
        :top_margin => 0,
        :botton_margin => 0
      )

      @document.font "Times-Roman"
    end

    def method_missing(method_name, *args, &block)
      @document.send(method_name, *args, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      @document.respond_to?(method_name, include_private) || super
    end

    def ititle(h, w, x, y, title)
      self.text_box title, :size => 10, :at => [x.cm, Helper.invert(y.cm) - 2], :width => w.cm, :height => h.cm, :style => :bold
    end

    def ibarcode(h, w, x, y, info)
      Barby::Code128C.new(info).annotate_pdf(self, :x => x.cm, :y => Helper.invert(y.cm), :width => w.cm, :height => h.cm) if info != ''
    end

    def irectangle(h, w, x, y)
      self.stroke_rectangle [x.cm, Helper.invert(y.cm)], w.cm, h.cm
    end

    def ibox(h, w, x, y, title = '', info = '', options = {})
      box [x.cm, Helper.invert(y.cm)], w.cm, h.cm, title, info, options
    end

    def idate(h, w, x, y, title = '', info = '', options = {})
      tt = info.split('-')
      ibox h, w, x, y, title, "#{tt[2]}/#{tt[1]}/#{tt[0]}", options
    end

    def box(at, w, h, title = '', info = '', options = {})
      options = {
        :align => :left,
        :size => 10,
        :style => nil,
        :valign => :top,
        :border => 1
      }.merge(options)
      self.stroke_rectangle at, w, h if options[:border] == 1
      self.text_box title, :size => 6, :style => :italic, :at => [at[0] + 2, at[1] - 2], :width => w - 4, :height => 8 if title != ''
      self.text_box info, :size => options[:size], :at => [at[0] + 2, at[1] - (title != '' ? 14 : 4) ], :width => w - 4, :height => h - (title != '' ? 14 : 4), :align => options[:align], :style => options[:style], :valign => options[:valign]
    end

    def inumeric(h, w, x, y, title = '', info = '', options = {})
      numeric [x.cm, Helper.invert(y.cm)], w.cm, h.cm, title, info, options
    end

    def numeric(at, w, h, title = '', info = '', options = {})
      options = {:decimals => 2}.merge(options)
      info = Helper.numerify(info, options[:decimals]) if info != ''
      box at, w, h, title, info, options.merge({:align => :right})
    end

    def itable(h, w, x, y, data, options = {}, &block)
      self.bounding_box [x.cm, Helper.invert(y.cm)], :width => w.cm, :height => h.cm do
        self.table data, options do |table|
          yield(table)
        end
      end
    end
  end
end
