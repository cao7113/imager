class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :image    #真实文件存储 file store
      t.string :source   #来源信息，如本地路径，url等, 保留原文件名信息
      t.text   :info     #相关信息, serialized as Hash
      t.string :md5
      t.timestamps null: false
    end
  end
end
