Sequel.migration do
  change do
    create_table :iso_local_files do
      primary_key :id
      foreign_key :iso_repo_id, :iso_repos
      index       :filename, unique: true

      String :filename,   null: false
      String :name,       null: false
    end
  end
end
