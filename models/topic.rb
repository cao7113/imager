require_relative 'uploaders/topic'

class Topic < ActiveRecord::Base
  serialize :info, Hash
  mount_uploader :image, Uploaders::Topic
  delegate :path, :content_type, :size, to: :image

  validates_uniqueness_of(:md5) unless env?(:development)

  before_validation :compute_md5, on: :create

  def compute_md5
    self.md5 ||= Digest::MD5.hexdigest(image.read.to_s)
  end

  def url version=:mini, opts={}
    version ||= :mini
    version = version.to_sym
    case version
    when :mini, :default
      image.mini.url(opts)
    when :raw, :original
      image.url opts
    else
      image.versions[version].try :url, opts
    end
  end
end
