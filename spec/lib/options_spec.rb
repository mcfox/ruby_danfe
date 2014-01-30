require "spec_helper"

describe RubyDanfe::Options do
  it "should return default config set in code" do
    options = RubyDanfe::Options.new
    expect(options.quantity_decimals).to eq(2)
  end

  it "should return config set in params" do
    options = RubyDanfe::Options.new({"quantity_decimals" => 4})
    expect(options.quantity_decimals).to eq(4)
  end
end
