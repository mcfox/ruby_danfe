require "spec_helper"

describe RubyDanfe::Helper do
  describe ".format_date" do
    it "returns a formated string" do
      string = "2013-10-18T13:54:04"
      expect(RubyDanfe::Helper.format_date(string)).to eq "18/10/2013 13:54:04"
    end
  end
end
