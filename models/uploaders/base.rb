module Uploaders
  class Base < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    storage :file   
    move_to_cache true 
    move_to_store true
    asset_host ENV['ASSET_HOST'] || 'http://localhost:9393'

    def md5
      return @md5 if @md5
      return @md5 = model.md5 if model.respond_to?(:md5) and model.md5
      chunk = model.send(mounted_as)
      @md5 ||= Digest::MD5.hexdigest(chunk.read.to_s)
    end
    
    def filename
      @name ||= "#{md5[4..-1]}.#{file.extension}" 
    end
    
    def store_dir
      #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      "uploads/#{md5[0..3]}"
    end

    # def default_url
    #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    # end

    version :default do 
      process :resize_to_fit => [100, 100]
    end

    version :mini do
      process :resize_to_fit => [50, 50]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end
  end
end
