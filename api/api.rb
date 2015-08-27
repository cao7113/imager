require 'grape'
require 'lib/uploaded_file'

module Imager
  class API < Grape::API
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
      imgfile = CarrierWave::SanitizedFile.new(params[:image])
      attrs = { image: imgfile, info: { filename: imgfile.filename } }
      topic = Topic.create!(attrs)
      topic
    end

    # use nginx instead in production
    params do
      requires :path, type: String, desc: 'path to a assets'
    end
    #get '/uploads/:path' do #todo
    get '/uploads' do
      path = File.join(CarrierWave.root, 'uploads', params[:path])
      raise "Not found #{path}" unless File.exists?(path)
      content_type MIME::Types.type_for(path)[0].to_s
      env['api.format'] = :binary # there's no formatter for :binary, data will be returned "as is"
      #header 'Content-Disposition', "attachment; filename*=UTF-8''#{URI.escape(path)}"
      File.new(path).read
    end

    resources :topics do
      desc 'get topic image by id'
      params do
        optional :version, type: String, desc: 'version'
      end
      get ':id' do
        topic = Topic.find(params[:id])
        env['api.format'] = :binary # there's no formatter for :binary, data will be returned "as is"
        content_type topic.content_type
        img = topic.image
        img = img.send(params[:version]) if params[:version]
        img.read
      end
    end
  end
end
