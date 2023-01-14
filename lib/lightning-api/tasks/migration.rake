require 'fileutils'

namespace :db do
  MIGRATIONS_DIR = 'db/migrations'

  desc "generates a migration file with a timestamp and name"
  task :generate_migration, :name do |_, args|
    args.with_defaults(name: 'migration')

    migration_template = <<~MIGRATION
      Sequel.migration do
        up do
        end

        down do
        end
      end
    MIGRATION

    file_name = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{args.name}.rb"
    FileUtils.mkdir_p(MIGRATIONS_DIR)

    File.open(File.join(MIGRATIONS_DIR, file_name), 'w') do |file|
      file.write(migration_template)
    end
  end

  namespace :migration do
    def database
      @database ||= begin
        require "sequel"
        Sequel.extension :migration
        Sequel.connect(
          adapter: :postgres,
          host: ENV['POSTGRES_HOST'],
          database: ENV['POSTGRES_DB'],
          username: ENV['POSTGRES_USER'],
          password: ENV['POSTGRES_PASSWORD']
        )
    end
    
    desc "Prints current schema version"
    task :version do    
      version = if database.tables.include?(:schema_info)
        database[:schema_info].first[:version]
      end || 0
  
      puts "Schema Version: #{version}"
    end
  
    desc "Perform migration up to latest migration available"
    task :migrate do
      Sequel::Migrator.run(database, MIGRATIONS_DIR)
      Rake::Task['db:migration:version'].execute
    end
      
    desc "Perform rollback to specified target or full rollback as default"
    task :rollback, :target do |t, args|
      args.with_defaults(:target => 0)
  
      Sequel::Migrator.run(database, MIGRATIONS_DIR, :target => args[:target].to_i)
      Rake::Task['db:migration:version'].execute
    end
  
    desc "Perform migration reset (full rollback and migration)"
    task :reset do
      Sequel::Migrator.run(database, MIGRATIONS_DIR, :target => 0)
      Sequel::Migrator.run(database, MIGRATIONS_DIR)
      Rake::Task['db:migration:version'].execute
    end

    desc "Add seeds to the database"
    task :seed, :filename do |t, args|
      args.with_defaults(:filename => 'seeds')
      seed_file = File.join(MIGRATIONS_DIR, "../#{args[:filename]}.rb")

      load seed_file if File.exists?(seed_file)
    end
  end
end
