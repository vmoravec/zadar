#require "bundler/gem_tasks"
#Dir.glob('lib/tasks/*.rake').each { |task| load task}
require 'active_record_migrations'

db_dir = Pathname.new(__dir__).join("lib/db")

ActiveRecordMigrations.configure do |c|
  c.db_dir = db_dir.to_path
  c.schema_format = :ruby
  c.yaml_config = db_dir.join("config.yml").to_path
  # c.environment = ENV['db']
  c.migrations_paths = [db_dir.join('migrate').to_path] # the first entry will be used by the generator
end

ActiveRecordMigrations.load_tasks
