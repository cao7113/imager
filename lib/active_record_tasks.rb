require_relative 'active_record_helper'

desc "set activerecord connection settings"
task :environment do
  #placeholder
end

namespace :db do
  desc "customize activerecord rake task settings"
  task :load_config do
    ActiveRecordHelper.conf_active_record_tasks
  end

  task :seed do
    ActiveRecordHelper.conf_active_record_tasks
  end

  namespace :migrate do
    desc 'generate a migration scaffold file, rake mig:new name=a_b_c'
    task :new, :name do |t, args|
      mig_version = Time.now.to_s(:number)
      name = args[:name]||ENV['name']||ENV['NAME']
      abort 'No name specified' unless name
      uname = name.underscore
      class_name = name.camelize
      data = <<-D
class #{class_name} < ActiveRecord::Migration
  def change
    #create_table :#{uname.pluralize} do |t|
    #  t.string :name,    limit: 50
    #  t.date   :birthday
    #  t.string :gender,  limit: 1
    #  t.timestamps null: false
    #end
    #
    #revert do |t|
    #  create_table :blogs do |t|
    #    t.string     :title,   limit: 100
    #    t.text       :content
    #    t.references :user
    #  end
    #end
  end
end
      D

      mig_path = ActiveRecordHelper.db_path.join('migrate')
      mig_path.mkpath

      file = mig_path.join "#{mig_version}_#{uname}.rb"
      File.write(file, data)
      puts "created file: #{file} with \n#{data}" 
    end
  end
end

load 'active_record/railties/databases.rake'
