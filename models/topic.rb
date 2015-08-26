require_relative 'uploaders/topic'

class Topic < ActiveRecord::Base
  serialize :info, Hash
  mount_uploader :image, Uploaders::Topic
  delegate :path, :content_type, :size, to: :image

  #validates_uniqueness_of(:md5) if env?(:production)

  before_validation :compute_md5, on: :create

  def compute_md5
    self.md5 ||= Digest::MD5.hexdigest(image.read.to_s)
  end
end
