module ApiHelper
  def api_host
    ENV['API_HOST'] || 'http://localhost:9292'
  end 

  def api_base(v1=nil)
    File.join(api_host, v1)
  end

  def api_v1
    api_base('v1')
  end

  def resp
    last_response
  end

  def raw_body
    last_response.body
  end

  def resp_status
    last_response.status
  end

  def resp_body
    JSON.parse(raw_body)
  end
end
