require 'smarter_csv'
require_relative 'merchant'

class MerchantRepository
  attr_reader :merchants

  def initialize(file)
    @merchants = parse_merchants(SmarterCSV.process(file))
  end

  def all
    merchants
  end

  def random
    merchants.sample
  end

  def find_by_id(id)
    merchants.detect {|merchant| merchant.id == id}
  end

  def find_by_name(name)
    merchants.detect { |merchant| merchant.name == name }
  end

  def find_by_created_at(created)
    merchants.detect { |merchant| merchant.created_at == created }
  end

  def find_by_updated_at(updated)
    merchants.detect { |merchant| merchant.updated_at == updated }
  end

  def find_all_by_id(id)
    merchants.select { |merchant| merchant.id == id }
  end

  def find_all_by_name(name)
    merchants.select { |merchant| merchant.name == name }
  end

  def find_all_by_created_at(created)
    merchants.select { |merchant| merchant.created_at == created }
  end

  def find_all_by_updated_at(updated)
    merchants.select { |merchant| merchant.updated_at == updated }
  end

  private
  def parse_merchants(csv_data)
    csv_data.map { |merchant| Merchant.new(merchant) }
  end
end
