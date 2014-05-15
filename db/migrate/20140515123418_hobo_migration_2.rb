class HoboMigration2 < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer  :follower_id
      t.integer  :followed_id
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :microposts, [:user_id]
  end

  def self.down
    drop_table :relationships

    remove_index :microposts, :name => :index_microposts_on_user_id rescue ActiveRecord::StatementInvalid
  end
end
