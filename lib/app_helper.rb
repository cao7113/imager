#require 'active_support/concern'

module AppHelper
  #extend ActiveSupport::Concern

  class << self
    attr_accessor :env
  end
  self.env = ENV['APP_ENV'] || :development

  def app_env
    AppHelper.env
  end

  def app_root
    ENV['APP_ROOT']
  end 

  def set_app_root root
    ENV['APP_ROOT'] = root
  end

  def env?(mode=:development)
    app_env.to_sym == mode.to_sym
  end

  def when_env mode
    if env?(mode) and block_given?
      yield 
    end
  end

  def when_not_env mode
    if !env?(mode) and block_given?
      yield
    end
  end

  def has_env? key, ignorecase=true
    key = key.to_s
    if ignorecase
      ENV.has_key?(key.upcase) or ENV.has_key?(key.downcase)
    else
      ENV.has_key?(key)
    end
  end
end

include AppHelper
