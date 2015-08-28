require 'tempfile'
require_relative 'uploaders/topic'

class Topic < ActiveRecord::Base
  serialize :info, Hash
  mount_uploader :image, Uploaders::Topic
  delegate :content_type, :size, :versions, to: :image

  validates_uniqueness_of(:md5) unless env?(:development)

  before_validation :compute_md5, on: :create

  scope :latest, ->{ order 'id desc' }

  def compute_md5
    self.md5 ||= Digest::MD5.hexdigest(image.read.to_s)
  end

  def v_image version=nil
    version = version.to_sym if version
    case version
    when :raw, :original # 原图
      image
    when :mini
      image.send(version)
    else # as default
      image.send :default
    end
  end

  def url version=nil, opts={}
    v_image(version).url(opts)
  end

  def path version=nil, opts={}
    v_image(version).path
  end

  def urls
    versions.inject({raw: url}) do |h, (k, v)|
      h[k] = v.url
      h
    end
  end

  def reversion!
    image.recreate_versions!
  end

  def self.upload_file path, opts={keep: true}
    old_path = path
    path = File.expand_path path
    if opts[:keep]
      file = Tempfile.new(['imager', File.extname(path)])
      file.write(File.read(path))
      puts "==use tmp file: #{file.path}"
    else
      file = File.open path
    end
    t = create! image: file, source: old_path 
    file.close if file and !file.closed?
    t
  end

  def as_simple_json(opts={})
    h = as_json only: [:id, :updated_at, :source]
    h[:url] = self.url
    h
  end

  def self.timeline opts={}
    clause = self
    if opts[:from_id]
      op = opts[:older] ? '<' : '>'
      clause = clause.where("id #{op} ?", opts[:from_id])
    end
    clause = clause.latest.limit(opts[:limit]||20)
  end
end
