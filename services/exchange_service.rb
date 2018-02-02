require 'date'
require 'bigdecimal'
require_relative '../db/models/exchange_rate'

class ExchangeService
  def self.exchange(amount, date_range = DateTime.now.prev_day(1))
    raise 'Date cannot be empty' if date_range.nil?
    raise 'Amount cannot be empty' if amount.nil?
    # should we add all posible validations here?
    amount = BigDecimal.new(amount.to_s)
    if date_range.is_a? Array
      ExchangeRate.where(created_at: date_range).each do |row|
        price = BigDecimal.new(row.price.to_s)
        date = row.created_at
        puts format_result(amount, price * amount, date)
      end
    else
      price = BigDecimal.new(ExchangeRate.where(created_at: date_range.to_date).first.price.to_s)
      puts format_result(amount, price * amount, date_range)
    end
  end

  def self.format_decimal(val)
    val.truncate(4).to_s('F')
  end

  def self.format_result(usd, eur, date)
    "#{format_decimal(usd)} USD in EUR is #{format_decimal(eur)} at #{date.to_date}"
  end
end