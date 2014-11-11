require 'active_record'

include ActiveRecord::Tasks
db_dir = Pathname.new(File.expand_path("../../db", __FILE__))
DatabaseTasks.env = 'development'
DatabaseTasks.database_configuration = YAML.load_file(db_dir.join('database.yml'))
DatabaseTasks.db_dir = db_dir.to_path
DatabaseTasks.migrations_paths = db_dir.join('migrate')

namespace :db do
  task :load_config do
    ActiveRecord::Base.configurations = ActiveRecord::Tasks::DatabaseTasks.database_configuration || {}
    ActiveRecord::Migrator.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
  end

  desc "Create new migration file"
  task :new_migration do
    puts 'Creating new migration'
  end

  desc "Run migration"
  task :migrate do
    Rake::Task["db:schema:dump"].invoke
  end

  task :environment do
  end
end
