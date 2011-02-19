desc "Run all specs"
task :spec do
  require 'rspec/core/rake_task'
 
  RSpec::Core::RakeTask.new
end
desc "Run migrations"
namespace :migrations do
  desc "Run migrations against dev database"
  task :development do
    gem "dm-core"
    require "dm-core"
    DataMapper.setup(:default, "sqlite3://#{File.join(File.dirname(__FILE__), 'db', "development.db")}")
    Rake::Task['migrations:migrate'].invoke
  end
  desc "Run migrations against test database"
  task :test do
    gem "dm-core"
    require "dm-core"
    DataMapper.setup(:default, "sqlite3://#{File.join(File.dirname(__FILE__), 'db', "test.db")}")
    Rake::Task['migrations:migrate'].invoke
  end
  task :production do
  end
  task :migrate do
    puts "Running migrate"
    gem "dm-migrations"
    require "dm-migrations"

    Dir[File.join(File.dirname(__FILE__), 'db', 'migrations', '*')].each { |f| puts f; require f}
    migrate_up!
  end
end

