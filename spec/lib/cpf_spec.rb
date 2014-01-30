require "spec_helper"

describe RubyDanfe::Cpf do
  describe ".format" do
    it "returns a formated CPF " do
      cpf = "61092121480"
      expect(RubyDanfe::Cpf.format(cpf)).to eq "610.921.214-80"
    end
  end
end
