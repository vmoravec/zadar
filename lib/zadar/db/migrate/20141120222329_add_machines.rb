class AddMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :name
      t.string :os_name
      t.string :os_version
      t.string :os_type, default: 'linux'
      t.integer :iso_id
      t.string :memory
      t.string :cpus
      t.string :disk_size
    end
  end
end
