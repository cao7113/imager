describe 'test' do

  def app
    Imager::API
  end

  it 'ping pong ok' do
    get api_v1 << '/ping'
    expect(raw_body).to eq 'pong'.to_json
  end

  let(:imgfile) { 
    imgfile = File.expand_path("../../data/test.jpg", __dir__) 
    Rack::Test::UploadedFile.new(imgfile)
  }

  it 'upload file' do
    attrs = {
      image: imgfile
    }
    post api_v1 << '/upload', attrs
    expect(resp_status).to eq 201
    expect(resp_body['filename']).to eq 'test.jpg'
  end
end
