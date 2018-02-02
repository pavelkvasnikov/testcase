# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require_relative 'db/connection'
require_relative 'services/downloader_service'
require_relative 'services/exchange_service'

connection = Connection.instance.db

task :create_db do
  connection.create_table :exchange_rates do
    primary_key :id
    Date :created_at, null: false, index: true, uniq: true
    BigDecimal :price, null: false
  end
  puts 'Database Created!'
end

task :drop_db do
  connection.drop_table :exchange_rates
  puts 'Database Dropped!'
end

task :populate_db do
  DownloaderService.populate_db
  puts 'DB is populated'
end

task :exchange_today, [:amount] do |t, args|
  ExchangeService.exchange(args[:amount])
end

task :exchange_last_week, [:amount] do |t, args|
  ExchangeService.exchange(args[:amount], [DateTime.now.prev_day(4).to_date, DateTime.now.prev_day(7).to_date])
end
