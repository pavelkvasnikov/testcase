class ExchangeRate < Sequel::Model
  def validate
    super
    validates_presence %i[price created_at]
    validates_numeric :price
    validates_type Date, :created_at
    validates_unique Date
  end
end