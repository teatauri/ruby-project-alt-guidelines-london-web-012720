require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
# require_all '../lib'
# require_all '../app'
require_all 'app'
require 'rest-client'
require 'json'
require 'net/http'
require 'uri'
