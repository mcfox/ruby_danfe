RSpec::Matchers.define(:be_same_file_as) do |exected_file_path|
  match do |actual_file_path|
    expect(md5_hash(actual_file_path)).to eq(md5_hash(exected_file_path))
  end

  def md5_hash(file_path)
    Digest::MD5.hexdigest(File.read(file_path))
  end
end
