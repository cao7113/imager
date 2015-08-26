module Uploaders
  class Base < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    storage :file   
    move_to_store true

    def md5
      return model.md5 if model.respond_to?(:md5) and model.send(:md5)
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

    # Process files as they are uploaded:
    #process :scale => [20, 20]
    #def scale(width, height)
      #resize_to_fit width, height
    #end

    # Create different versions of your uploaded files:
    version :mini do 
      process :resize_to_fit => [50, 50]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end
  end
end
