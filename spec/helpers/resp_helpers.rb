module RespHelpers
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
