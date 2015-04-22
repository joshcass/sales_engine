require 'smarter_csv'
require_relative 'customer'

class CustomerRepository
  def initialize(filename = "./data/customers.csv")
    @csv_data = SmarterCSV.process(filename)
    @customers = @csv_data.map do |customer| 
      Customer.new(customer)
    end
  end

  def all
    @customers
  end

  def random
    @customers.sample
  end

  def find_by_id(search_id)
    @customers.detect { |customer| search_id == customer.id }
  end

  def find_all_by_id(search_id)
    @customers.select { |customer| search_id == customer.id }
  end

  def find_by_first_name(search_name)
    @customers.detect { |customer| search_name.downcase == customer.first_name.downcase}
  end

  def find_all_by_first_name(search_name)
    @customers.select { |customer| search_name.downcase == customer.first_name.downcase }
  end

  def find_by_last_name(search_name)
    @customers.detect { |customer| search_name.downcase == customer.last_name.downcase}
  end

  def find_all_by_last_name(search_name)
    @customers.select { |customer| search_name.downcase == customer.last_name.downcase }
  end

  def find_by_created_at(search_time)
    @customers.detect { |customer| search_time == customer.created_at}
  end

  def find_all_by_created_at(search_time)
    @customers.select { |customer| search_time == customer.created_at }
  end

  def find_by_updated_at(search_time)
    @customers.detect { |customer| search_time == customer.updated_at}
  end

  def find_all_by_updated_at(search_time)
    @customers.select { |customer| search_time == customer.updated_at }
  end
end