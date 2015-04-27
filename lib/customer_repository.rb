require 'smarter_csv'
require_relative 'customer'

class CustomerRepository
  attr_reader :sales_engine, :customers

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(csv_data, sales_engine)
    @customers = parse_customers(csv_data, self)
    @sales_engine = sales_engine
  end

  def all
    customers
  end

  def random
    customers.sample
  end

  def find_by_id(search_id)
    customers.detect { |customer| search_id == customer.id }
  end

  def find_all_by_id(search_id)
    customers.select { |customer| search_id == customer.id }
  end

  def find_by_first_name(search_name)
    customers.detect do |customer|
      search_name.downcase == customer.first_name.downcase
    end
  end

  def find_all_by_first_name(search_name)
    customers.select do |customer|
      search_name.downcase == customer.first_name.downcase
    end
  end

  def find_by_last_name(search_name)
    customers.detect do |customer|
      search_name.downcase == customer.last_name.downcase
    end
  end

  def find_all_by_last_name(search_name)
    customers.select do |customer|
      search_name.downcase == customer.last_name.downcase
    end
  end

  def find_by_created_at(search_time)
    customers.detect { |customer| search_time == customer.created_at}
  end

  def find_all_by_created_at(search_time)
    customers.select { |customer| search_time == customer.created_at }
  end

  def find_by_updated_at(search_time)
    customers.detect { |customer| search_time == customer.updated_at}
  end

  def find_all_by_updated_at(search_time)
    customers.select { |customer| search_time == customer.updated_at }
  end

  def find_all_invoices(id)
    sales_engine.find_invoices_by_customer_id(id)
  end

  def new_customer(customer)
    customers << customer if customers.none? do |a_customer|
      a_customer == customer
    end
  end

  private
  def parse_customers(csv_data, repo)
    csv_data.map { |invoice| Customer.new(invoice, repo) }
  end
end
