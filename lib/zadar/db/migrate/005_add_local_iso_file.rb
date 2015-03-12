Sequel.migration do
  change do
    create_table :local_iso_files do
      primary_key :id
      foreign_key :local_iso_repo_id, :local_iso_repos
      index       :filename, unique: true

      String  :filename,   null: false
      String  :name,       null: false
      Integer :size,       null: false, default: 0
      Integer :ctime,     null: false
      Integer :mtime,     null: false
      String  :md5
      String  :sha1
      String  :sha256
    end
  end
end
