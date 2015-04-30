require_relative 'customer'

class CustomerRepository
  attr_reader :sales_engine, :customers, :id

  def inspect
    "#<#{self.class} #{@customers.size} rows>"
  end

  def initialize(customer_hashes, sales_engine)
    @customers = parse_customers(customer_hashes, self)
    @sales_engine = sales_engine
  end

  def build_hash_tables
    @id = customers.group_by{ |customer| customer.id }
  end

  def all
    customers
  end

  def random
    customers.sample
  end

  def find_by_id(search_id)
    id[search_id].first
  end

  def find_by_first_name(search_name)
    customers.detect { |customer| customer.first_name == search_name }
  end

  def find_all_by_first_name(search_name)
    customers.select { |customer| customer.first_name == search_name }
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

  def find_invoices(id)
    sales_engine.find_invoices_by_customer_id(id)
  end

  def find_invoice_items(invoices)
    invoices.flat_map do |invoice|
      sales_engine.find_all_invoice_items_by_invoice_id(invoice.id)
    end
  end

  def total_items_purchased(invoice_items)
    sales_engine.find_total_quantity(invoice_items)
  end

  def total_spent(invoice_items)
    sales_engine.find_total_revenue(invoice_items)
  end

  def most_items
    customers.max_by { |customer| customer.items_purchased}
  end

  def most_revenue
    customers.max_by { |customer| customer.spent}
  end

  private
  def parse_customers(customer_hashes, repo)
    customer_hashes.map do |attributes_hash|
      Customer.new(attributes_hash, repo)
    end
  end
end
