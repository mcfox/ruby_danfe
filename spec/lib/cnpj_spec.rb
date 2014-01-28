require "spec_helper"

describe RubyDanfe::Cnpj do
  describe ".format" do
    it "returns a formated CNPJ" do
      cnpj = "32624223000116"
      expect(RubyDanfe::Cnpj.format(cnpj)).to eq "32.624.223/0001-16"
    end
  end
end
