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
    #net_url = 'http://tp4.sinaimg.cn/1809866795/180/5665149016/1'
    net_url1 = 'http://img6.cache.netease.com/photo/0001/2015-08-28/B24R21D519BR0001.jpg'
    post '/upload', image_url: net_url1
    puts resp_body.inspect
    expect(resp_status).to eq 201
  end
end
