class AddUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :login
      t.string :admin, default: false
      t.integer :uid
      t.integer :gid
    end
  end
end
