class Topic < ActiveRecord::Base
  serialize :content, Hash
  mount_uploader :image, TopicUploader

  delegate :path, :content_type, :size, to: :image
end
