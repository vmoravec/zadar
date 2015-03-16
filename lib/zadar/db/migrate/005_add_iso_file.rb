Sequel.migration do
  change do
    create_table :iso_files do
      primary_key :id
      foreign_key :iso_repo_id, :iso_repos, null: false
      index       :filename, unique: true, null: false
      index       :url, unique: true, null: false
      index       [:filename, :iso_repo_id], unique: true

      String  :url,      null: false
      String  :filename, null: false
      String  :mirror
      Integer :size
      Integer :mtime
      Integer :ctime
      String  :md5
      String  :sha1
      String  :sha256
    end
  end
end
