require "spec_helper"

describe "RubyDanfe generated pdf files" do
  let(:base_dir) { "./spec/fixtures/"}
  let(:output_pdf) { "#{base_dir}output.pdf" }

  before { File.delete(output_pdf) if File.exist?(output_pdf) }

  it "renders a basic NF-e with namespace" do
    expect(File.exist?(output_pdf)).to be_false

    RubyDanfe.generate(output_pdf, "#{base_dir}nfe_with_ns.xml")

    expect("#{base_dir}nfe_with_ns.xml.fixture.pdf").to be_same_file_as(output_pdf)
  end

  it "renders another basic NF-e without namespace" do
    expect(File.exist?(output_pdf)).to be_false

    RubyDanfe.generate(output_pdf, "#{base_dir}nfe_without_ns.xml")

    expect("#{base_dir}nfe_without_ns.xml.fixture.pdf").to be_same_file_as(output_pdf)
  end

  it "renders a NF-e having FCI in its items" do
    expect(File.exist?(output_pdf)).to be_false

    RubyDanfe.generate(output_pdf, "#{base_dir}nfe_with_fci.xml")

    expect("#{base_dir}nfe_with_fci.xml.fixture.pdf").to be_same_file_as(output_pdf)
  end

  it "renders a NF-e of Simples Nacional using CSOSN" do
    expect(File.exist?(output_pdf)).to be_false

    RubyDanfe.generate(output_pdf, "#{base_dir}nfe_simples_nacional.xml")

    expect("#{base_dir}nfe_simples_nacional.xml.fixture.pdf").to be_same_file_as(output_pdf)
  end
end
