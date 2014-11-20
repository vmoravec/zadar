class AddProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :path
      t.integer :user_id
    end
  end
end
