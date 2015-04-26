require 'bigdecimal'

module BusinessIntelligence
  # sales_engine methods
  def find_total_revenue_for_invoice_items(invoice_items)
    invoice_item_repository.total_revenue_for_invoice_items(invoice_items)
  end

  def find_total_quantity_for_invoice_items(invoice_items)
    invoice_item_repository.total_quantity_for_invoice_items(invoice_items)
  end

  def add_new_customer(customer)
    customer_repository.new_customer(customer)
  end

  def add_new_merchant(merchant)
    merchant_repository.new_merchant(merchant)
  end

  def add_new_items(items)
    item_repository.new_items(items)
  end

  def add_new_invoice_items(invoice_id, items)
    invoice_item_repository.new_invoice_items(invoice_id, items)
  end

  def add_new_transaction(invoice_id, data_hash)
    transaction_repository.new_transaction(invoice_id, data_hash)
  end

  # transaction_repository methods
  def new_transaction(invoice_id, data_hash)
    new_id = transactions.max_by { |transaction| transaction.id }.id + 1
    transactions << Transaction.new({id: new_id,
        invoice_id: invoice_id,
        credit_card_number: data_hash[:credit_card_number],
        credit_card_expiration_date: data_hash[:credit_card_expiration_date],
        result: data_hash[:result],
        created_at: "#{Time.now.utc}",
        updated_at: "#{Time.now.utc}"}, self)
  end

  # customer_repository methods
  def new_customer(customer)
    customers << customer if customers.none? { |a_customer| a_customer == customer}
  end

  # invoice_item_repository methods
  def total_revenue_for_invoice_items(invoice_items)
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + (invoice_item.quantity * BigDecimal(".#{invoice_item.unit_price}"))
    end.round(2)
  end

  def total_quantity_for_invoice_items(invoice_items)
    invoice_items.reduce(0) { |sum, invoice_item| sum + invoice_item.quantity }
  end

  def group_items_by_quantity(items)
    items.group_by { |item| item }
  end

  def add_invoice_item(invoice_id, item, quantity)
    new_id = invoice_items.max_by { |invoice_item| invoice_item.id }.id + 1
    invoice_items << InvoiceItem.new({id: new_id,
        item_id: item.id,
        invoice_id: invoice_id,
        quantity: quantity,
        unit_price: item.unit_price,
        created_at: Time.now.utc,
        updated_at: Time.now.utc}, self)
  end

  def new_invoice_items(invoice_id, items)
    group_items_by_quantity(items).each { |item, quantity| add_invoice_item(invoice_id, item, quantity.length) }
  end

  # invoice_repository methods
  def new_invoice(data_hash)
    new_id = invoices.max_by { |invoice| invoice.id }.id + 1
    invoices << Invoice.new({id: new_id,
        customer_id: data_hash[:customer].id,
        merchant_id: data_hash[:merchant].id,
        status: data_hash[:status],
        created_at: "#{Time.now.utc}",
        updated_at: "#{Time.now.utc}"}, self)
    find_by_id(new_id)
  end

  def create(data_hash)
    sales_engine.add_new_customer(data_hash[:customer])
    sales_engine.add_new_merchant(data_hash[:merchant])
    sales_engine.add_new_items(data_hash[:items])
    invoice = new_invoice(data_hash)
    sales_engine.add_new_invoice_items(invoice.id, data_hash[:items])
    invoice
  end

  def add_transaction(invoice_id, data_hash)
    sales_engine.add_new_transaction(invoice_id, data_hash)
  end

  # item_repository methods
  def new_items(items_to_add)
    items << items_to_add.uniq.reject { |item| items.include?(item) }
  end

  # merchant_repository methods
  def find_total_revenue(invoice_items)
    sales_engine.find_total_revenue_for_invoice_items(invoice_items)
  end

  def total_items_sold(invoice_items)
    sales_engine.find_total_quantity_for_invoice_items(invoice_items)
  end

  def most_revenue(top_n)
    merchants.sort_by { |merchant| merchant.revenue }.take(top_n)
  end

  def most_items(top_n)
    merchants.sort_by { |merchant| merchant.items_sold}.take(top_n)
  end

  # def revenue(date)
  # calls merchant.revenue(date) on all merchants
  # totals up revenue
  # end

  def new_merchant(merchant)
    merchants << merchant if merchants.none? { |a_merchant| a_merchant == merchant}
  end
end
