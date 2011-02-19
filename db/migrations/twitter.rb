require 'dm-migrations/migration_runner'

migration 1, :create_twitter_table do
  up do
    create_table :twitter do
      column :request_token, String
      column :request_secret, String
      column :oauth_verification, String
    end
  end
end
