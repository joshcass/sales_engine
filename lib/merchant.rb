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

  def invoices
    parent.find_all_invoices(id)
  end

  def revenue
    parent.find_total_revenue(invoices)
  end

  def items_sold
    parent.total_items_sold(invoices)

    # calls out to sales engine

    # check each invoice against transactions and eliminate failed transactions => reuse
    # once it has invoices it looks up invoice items => method already exists
    # takes quantity of items for each invoice
    # adds up total quantity for the merchant
    # return total_items_sold to caller
  end

  # def favorite_customer
    # looks up all invoices for merchant => method already exists
    # check each invoice against transactions and eliminate failed transactions => reuse
    # find customer id that appears on most invoices
    # look up customer by id
    # return that back to caller
  # end

  # def customers_with_pending_invoices
    # looks up all invoices for merchant => method already exists
    # check each invoice against transactions and eliminate successful transactions => need this method
    # look up all customers from those invoices
    # return customers to caller
  # end

end
