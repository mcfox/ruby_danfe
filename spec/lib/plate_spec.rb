require "spec_helper"

describe RubyDanfe::Plate do
  describe ".format_plate" do
    it "returns a formated plate" do
      plate = "ABC1234"
      expect(RubyDanfe::Plate.format(plate)).to eq "ABC-1234"
    end
  end
end
