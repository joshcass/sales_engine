require_relative 'business_intelligence'
include BusinessIntelligence

class Customer
  attr_reader :customer, :parent

  def initialize(customer, parent)
    @customer = customer
    @parent = parent
  end

  def id
    customer[:id]
  end

  def first_name
    customer[:first_name]
  end

  def last_name
    customer[:last_name]
  end

  def created_at
    customer[:created_at]
  end

  def updated_at
    customer[:updated_at]
  end

  def favorite_merchant
    invoices.group_by do |invoice|
        invoice.merchant
      end.max_by do |merchant, quantity|
        quantity.length
      end.first
  end
end
