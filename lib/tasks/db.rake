namespace :db do
  desc "Run migrations upwards"
  task :migrate, [:version] do |t, args|
    require "sequel"

    abort "No migrations to run" if Sequel::Migrator.is_current?

    Sequel.extension :migration
    db = Sequel.connect(ENV.fetch("DATABASE_URL"))
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end

  desc "Rollback migrations"
  task :rollback do
  end


end
