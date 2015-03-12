Sequel.migration do
  change do
    create_table :remote_iso_files do
      primary_key :id
      foreign_key :remote_iso_repo_id, null: false
      index       [:url, :remote_iso_repo_id], unique: true
      index       [:filename, :remote_iso_repo_id], unique: true

      String :url, null: false
      String :filename, null: false
      Integer :size, null: false
      DateTime :mtime, null: false
      String :mirror
      String :md5
      String :sha1
      String :sha256
    end
  end
end
