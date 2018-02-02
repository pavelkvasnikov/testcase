require 'rspec'
require 'sequel'
require_relative '../db/connection'
require_relative '../services/exchange_service'
require_relative '../db/models/exchange_rate'
require 'bigdecimal'
require 'date'

RSpec.describe ExchangeService do

##########################################################################
## Next time use something friendly to factory bot and also use FFaker) ##
##########################################################################

  describe '#format_decimal' do
    it 'should format decimal' do
      decimal = BigDecimal.new('100.4444666')
      expect(described_class.format_decimal(decimal)).to eq('100.4444')
      expect(described_class.format_decimal(decimal)).not_to eq(decimal)
    end

    it 'should not format garbage' do
      decimal = 'string'
      expect { described_class.format_decimal(decimal) }.to raise_error(NoMethodError)
    end
  end

  describe '#print_result' do
    it 'should prints proper string' do
      usd =  BigDecimal.new('100.4444666')
      date = DateTime.now
      string = "100.4444 USD in EUR is 100.4444 at #{date.to_date.to_s}"
      expect(described_class.format_result(usd, usd, date)).to eq string
      expect { described_class.format_result(usd, 'garbage', date) }.to raise_error(NoMethodError)
    end
  end

  describe '#exchange' do
    before(:all) do
      portion = [
        ['2018-02-01', '1.2459'],
        ['2018-01-01', '1.2489']
      ]
      ExchangeRate.dataset.delete
      ExchangeRate.import(%i[created_at price], portion)
    end

    specify do
      single_string = "300.0 USD in EUR is 373.77 at 2018-02-01\n"
      expect { described_class.exchange(300, Date.parse('2018-02-01')) }.to output(single_string).to_stdout
    end

    specify do
      single_string = "300.0 USD in EUR is 374.67 at 2018-01-01\n300.0 USD in EUR is 373.77 at 2018-02-01\n"
      expect do
        described_class.exchange(300, [Date.parse('2018-02-01'), Date.parse('2018-01-01')])
      end
        .to output(single_string).to_stdout
    end

    describe '#exchange' do
      it 'should check params' do
        expect { described_class.exchange(100, nil) }.to raise_error('Date cannot be empty')
        expect { described_class.exchange(nil, 100) }.to raise_error('Amount cannot be empty')
      end
    end
  end
end