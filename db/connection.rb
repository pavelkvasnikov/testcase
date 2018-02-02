require 'sequel'
require 'singleton'

class Connection
  include Singleton
  attr_reader :db

  def initialize
    @db = Sequel.connect(ENV['connection-string'] || 'sqlite://test.db')
  end
end

DB = Connection.instance # Sequel issue, requires exactly DB name for variable