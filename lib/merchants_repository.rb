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
    merchants.detect do |merchant|
      merchant.id == id
    end
  end

  def find_by_name(name)
    merchants.detect do |merchant|
      merchant.name == name
    end
  end

  def find_by_created_at(created)
    merchants.detect do |merchant|
      merchant.created_at == created
    end
  end

  def find_by_updated_at(updated)
    merchants.detect do |merchant|
      merchant.updated_at == updated
    end
  end

  def find_all_by_id(id)
    merchants.select do |merchant|
      merchant.id == id
    end
  end

  def find_all_by_name(name)
    merchants.select do |merchant|
      merchant.name == name
    end
  end

  def find_all_by_created_at(created)
    merchants.select do |merchant|
      merchant.created_at == created
    end
  end

  def find_all_by_updated_at(updated)
    merchants.select do |merchant|
      merchant.updated_at == updated
    end
  end

  private
  def parse_merchants(csv_data)
    csv_data.map do |merchant|
      Merchant.new(merchant)
    end
  end
end
