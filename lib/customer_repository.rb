require_relative 'customer'

class CustomerRepository
  attr_reader :sales_engine, :customers, :id_group, :first_name_group

  def inspect
    "#<#{self.class} #{@customers.size} rows>"
  end

  def initialize(csv_data, sales_engine)
    @customers = parse_customers(csv_data, self)
    @sales_engine = sales_engine
    @id_group = @customers.group_by{ |customer| customer.id }
    @first_name_group = @customer.group_by{ |customer| customer.first_name}
  end

  def all
    customers
  end

  def random
    customers.sample
  end

  def find_by_id(search_id)
    id_group[search_id].first
  end

  def find_by_first_name(search_name)
    first_name_group[search_name].first
  end

  def find_all_by_first_name(search_name)
    first_name_group[search_name]
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
    invoices.map do |invoice|
      sales_engine.find_all_invoice_items_by_invoice_id(invoice.id)
    end.flatten
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
  def parse_customers(csv_data, repo)
    csv_data.map { |invoice| Customer.new(invoice, repo) }
  end
end
