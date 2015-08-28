require 'grape'
module Imager; end
require_relative 'topic_api'

class Imager::API < Grape::API
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
    optional :image, type: Rack::Multipart::UploadedFile, desc: '上传文件' #, documentation: { param_type: 'form' }
    optional :image_url, type: String, desc: 'remote image url'
    exactly_one_of :image, :image_url
  end
  post :upload do
    if params[:image_url]
      attrs = { remote_image_url: params[:image_url], source: params[:image_url] }
    else
      imgfile = CarrierWave::SanitizedFile.new(params[:image])
      attrs = { image: imgfile, source: imgfile.filename }
    end
    topic = Topic.create!(attrs)
    topic
  end

  ## use nginx instead in production
  #params do
    #requires :path, type: String, desc: 'path to a assets'
  #end
  ##get '/uploads/:path' do #todo
  #get '/uploads/:path' do
    #byebug
    #path = File.join(CarrierWave.root, 'uploads', params[:path])
    #raise "Not found #{path}" unless File.exists?(path)
    #content_type MIME::Types.type_for(path)[0].to_s
    #env['api.format'] = :binary # there's no formatter for :binary, data will be returned "as is"
    ##header 'Content-Disposition', "attachment; filename*=UTF-8''#{URI.escape(path)}"
    #File.new(path).read
  #end

  mount Imager::TopicAPI
end
