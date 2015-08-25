class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :raw_path #原路径，主要记录原文件名 original_filename
      t.string :image    #真实文件存储 file store
      t.string :md5
      t.text   :info     #相关信息, serialize as Hash
      t.timestamps null: false
    end
  end
end
