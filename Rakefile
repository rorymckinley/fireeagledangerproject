desc "Run all specs"
task :spec do
  require 'rspec/core/rake_task'
 
  RSpec::Core::RakeTask.new
end
namespace :migrations do
  namespace :development do
    task :connection do
      gem "dm-core"
      require "dm-core"
      DataMapper.setup(:default, "sqlite3://#{File.join(File.dirname(__FILE__), 'db', "development.db")}")
    end
    desc "Migrate up the development database"
    task :up => 'development:connection' do
      Rake::Task['migrations:migrate'].invoke
    end
    desc "Migrate down the development database"
    task :down => 'development:connection' do
      Rake::Task['migrations:migrate_down'].invoke
    end
  end
  namespace :test do
    task :connection do
      gem "dm-core"
      require "dm-core"
      DataMapper.setup(:default, "sqlite3://#{File.join(File.dirname(__FILE__), 'db', "test.db")}")
    end
    desc "Migrate up the test database"
    task :up => 'test:connection' do
      Rake::Task['migrations:migrate'].invoke
    end
    desc "Migrate down the test database"
    task :down => 'test:connection' do
      Rake::Task['migrations:migrate_down'].invoke
    end
  end
  task :production do
    task :connection do
      gem "dm-core"
      require "dm-core"
      DataMapper.setup(:default,ENV["DATABASE_URL"])
    end
    desc "Migrate up the production database"
    task :up => 'production:connection' do
      Rake::Task['migrations:migrate'].invoke
    end
    desc "Migrate down the production database"
    task :down => 'production:connection' do
      Rake::Task['migrations:migrate_down'].invoke
    end
  end
  task :migrate do
    gem "dm-migrations"
    require "dm-migrations"

    Dir[File.join(File.dirname(__FILE__), 'db', 'migrations', '*')].each { |f| puts f; require f}
    migrate_up!
  end
  task :migrate_down do
    gem "dm-migrations"
    require "dm-migrations"

    Dir[File.join(File.dirname(__FILE__), 'db', 'migrations', '*')].each { |f| puts f; require f}
    migrate_down!
  end
end
