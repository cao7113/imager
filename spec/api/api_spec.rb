describe 'test' do

  def app
    Imager::API
  end

  #it 'ping pong ok' do
    #get api_v1 << '/ping'
    #expect(raw_body).to eq 'pong'.to_json
  #end

  #it 'upload file' do
    #attrs = {
      #image: Rack::Test::UploadedFile.new('data/test.jpg')
    #}
    #post api_v1 << '/upload', attrs
    #puts resp_body.inspect
    #expect(resp_status).to eq 201
  #end

  it 'upload a chinese named file' do
    post api_v1 << '/upload', image: Rack::Test::UploadedFile.new('data/中文文件.jpg')
    puts resp_body.inspect
    expect(resp_status).to eq 201
  end
end
