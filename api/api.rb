require 'grape'
require 'lib/uploaded_file'

module Imager
  class API < Grape::API

    version :v1, using: :path
    format :json

    get :ping do
      'pong'
    end

    get :stat do
      {
        topics_count: Topic.count
      }
    end

    params do
      requires :image, type: Rack::Multipart::UploadedFile, desc: '上传文件' #, documentation: { param_type: 'form' }
    end
    post :upload do
      img = params[:image]
      attrs = { raw_path: img[:filename], image: img[:tempfile] } #or UploadedFile.new(img).tempfile
      topic = Topic.create(attrs)
      # todo as_json error
      { id: topic.id,
        path: topic.image.path,
        filename: topic.raw_path
      }
    end

    #异步长传支持 callback to update asset url
  end
end
