Sequel.migration do
  change do
    create_table :projects do
      primary_key :id
      foreign_key :user_id, :users

      String  :name
      String  :path
    end
  end
end
