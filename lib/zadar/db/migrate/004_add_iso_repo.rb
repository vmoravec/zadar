Sequel.migration do
  change do
    create_table :iso_repos do
      primary_key :id
      index       :url, unique: true
      index       :name, unique: true
      index       :type

      String :url, null: false
      String :name, null: false
      String :type, null: false
      String :local_path, null: false
    end
  end
end
