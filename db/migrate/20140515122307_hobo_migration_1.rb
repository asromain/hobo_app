class HoboMigration1 < ActiveRecord::Migration
  def self.up
    create_table :microposts do |t|
      t.string   :content
      t.integer  :user_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :microposts
  end
end
