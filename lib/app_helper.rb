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
end

include AppHelper
