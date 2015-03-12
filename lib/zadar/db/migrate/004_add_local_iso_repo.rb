Sequel.migration do
  change do
    create_table :local_iso_repos do
      primary_key :id
      index       :path, unique: true
      index       :name, unique: true

      String :path, null: false
      String :name, null: false
    end
  end
end
