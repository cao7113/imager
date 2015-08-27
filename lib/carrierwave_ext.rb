module CarrierWave
  module Uploader
    # ref: https://github.com/carrierwaveuploader/carrierwave/wiki/How-To%3A-Move-version-name-to-end-of-filename%2C-instead-of-front
    # suffix version to filename for better group
    module Versions
      def full_filename(for_file)
        parent_name = super(for_file)
        #if file # ??
          #ext         = file.extension
          #base_name   = file.basename
        #else
          #raise 'Not found file'
          ext         = File.extname(parent_name)
          base_name   = parent_name.chomp(ext)
        #end
        [base_name, version_name].compact.join('_') + ext
      end

      def full_original_filename
        parent_name = super
        ext         = File.extname(parent_name)
        base_name   = parent_name.chomp(ext)
        [base_name, version_name].compact.join('_') + ext
      end
    end # versions
  end # uploader
end # CarrierWave
