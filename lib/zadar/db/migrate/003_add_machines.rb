Sequel.migration do
  change do
    create_table :machines do
      primary_key :id

      String :name
      String :os_name
      String :os_version
      String :os_family
      String :os_type, default: 'linux'
    end
  end
end
