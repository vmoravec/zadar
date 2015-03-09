Sequel.migration do
  change do
    create_table :remote_iso_repos do
      primary_key :id
      index       :url, unique: true
      index       :name, unique: true
      index       :type

      String :url, null: false
      String :name, null: false
      String :type, null: false
    end
  end
end
