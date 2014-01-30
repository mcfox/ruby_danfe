module RubyDanfe
  class Plate
    def self.format(plate)
      plate.sub(/(\w{2})(\d{4})/, "\\1-\\2")
    end
  end
end
