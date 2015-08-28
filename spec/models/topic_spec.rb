require 'fileutils'

describe 'topics' do
  let(:file) { 'data/test.jpg' }

  it 'upload local file, keep raw file' do
    t = Topic.upload_file file
    expect(File.exists?(t.path)).to eq true
  end

  it 'upload local file, remove raw file' do
    newp = 'data/test1.jpg' 
    FileUtils.cp file, newp unless File.exists? newp
    t = Topic.upload_file newp, keep: false
    expect(File.exists?(newp)).to eq false
    expect(File.exists?(t.path)).to eq true
  end

  when_env :test do
    it 'remove image after destroy when transaction is committed (enabled case)' do
      t = Topic.upload_file file
      t.destroy 
      expect(File.exists?(t.path)).to eq $cleaner_strategy == :transaction
    end
  end
end
