require_relative 'business_intelligence'
include BusinessIntelligence

class Merchant
  attr_reader :merchant, :parent

  def initialize(merchant, parent)
    @merchant = merchant
    @parent = parent
  end

  def id
    merchant[:id]
  end

  def name
    merchant[:name]
  end

  def created_at
    merchant[:created_at]
  end

  def updated_at
    merchant[:updated_at]
  end

  def items
    parent.find_all_items(id)
  end

  def items_sold
    parent.total_items_sold(successful_invoice_items)
  end

  def favorite_customer
    successful_invoices.group_by do |invoice|
        invoice.customer
      end.max_by do |customer, quantity|
        quantity.length
      end.first
  end

  def customers_with_pending_invoices
    pending_invoices.map { |invoice| invoice.customer}
  end
end
