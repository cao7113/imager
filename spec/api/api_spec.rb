describe 'test' do

  def app
    Imager::API
  end

  #it 'ping pong ok' do
    #get '/ping'
    #expect(raw_body).to eq 'pong'.to_json
  #end

  it 'upload chinese named file' do
    post '/upload', image: Rack::Test::UploadedFile.new('data/中文文件.jpg')
    puts resp_body.inspect
    expect(resp_status).to eq 201
  end

  it 'download and store a remote url' do
    wb_head_url = 'http://tp4.sinaimg.cn/1809866795/180/5665149016/1'
    post '/upload', image_url: wb_head_url
    puts resp_body.inspect
    expect(resp_status).to eq 201
  end
end
