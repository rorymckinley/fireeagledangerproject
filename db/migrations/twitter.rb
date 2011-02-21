require 'dm-migrations/migration_runner'

migration 1, :create_twitter_table do
  up do
    create_table :twitter do
      column :request_token, String
      column :request_secret, String
      column :access_token, String
      column :access_secret, String
    end
  end
  down do
    drop_table :twitter
  end
end
