class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :image    #真实文件存储 file store
      t.string :md5
      t.text   :info     #相关信息, serialize as Hash
      t.timestamps null: false
    end
  end
end
